import '../models/forecast.dart';
import '../sources/api_client.dart';

/// Repository interface for forecasts
abstract class ForecastsRepository {
  /// Get a list of all forecasts
  Future<List<Forecast>> getForecasts({bool useMock = true});
  
  /// Get a specific forecast by ID
  Future<Forecast?> getForecastById(int id, {bool useMock = true});
  
  /// Get forecasts for a specific period
  Future<List<Forecast>> getForecastsByPeriod(String period, {bool useMock = true});
  
  /// Get forecasts for a specific service
  Future<List<Forecast>> getForecastsByServiceId(int serviceId, {bool useMock = true});
}

/// Implementation of ForecastsRepository
class ForecastsRepositoryImpl implements ForecastsRepository {
  final ApiClient _apiClient;
  
  ForecastsRepositoryImpl(this._apiClient);
  
  @override
  Future<List<Forecast>> getForecasts({bool useMock = false}) async {
    try {
      List<dynamic> data = [];
      
      if (useMock) {
        data = await _apiClient.getMockData('forecasts');
        return data.map((json) => Forecast.fromJson(json)).toList();
      } else {
        // Use the dedicated forecasts endpoint
        final response = await _apiClient.get('api/mdn-previsions?populate[mdn_service_numerique][populate]=*&populate[mdn_qualite_de_service_prevision]=*');
        
        // Check if response is in Strapi format with data array
        if (response is Map<String, dynamic> && response.containsKey('data')) {
          data = response['data'] as List<dynamic>;
          
          // Map data to Forecast objects
          return data.map((json) => Forecast.fromStrapi5Json(json)).toList();
        } else {
          throw Exception('Unexpected API response format');
        }
      }
    } catch (e) {
      throw Exception('Failed to load forecasts: $e');
    }
  }
  
  @override
  Future<Forecast?> getForecastById(int id, {bool useMock = true}) async {
    try {
      final forecasts = await getForecasts(useMock: useMock);
      return forecasts.firstWhere((forecast) => forecast.id == id);
    } catch (e) {
      throw Exception('Failed to find forecast with ID $id: $e');
    }
  }
  
  @override
  Future<List<Forecast>> getForecastsByPeriod(String period, {bool useMock = true}) async {
    final forecasts = await getForecasts(useMock: useMock);
    final now = DateTime.now();
    
    if (period == 'today') {
      return forecasts.where((forecast) {
        if (forecast.startDate == null) return false;
        final date = DateTime.parse(forecast.startDate!);
        return date.year == now.year && 
               date.month == now.month && 
               date.day == now.day;
      }).toList();
    } else if (period == 'week') {
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      
      return forecasts.where((forecast) {
        if (forecast.startDate == null) return false;
        final date = DateTime.parse(forecast.startDate!);
        return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) && 
               date.isBefore(endOfWeek.add(const Duration(days: 1)));
      }).toList();
    } else if (period == 'month') {
      return forecasts.where((forecast) {
        if (forecast.startDate == null) return false;
        final date = DateTime.parse(forecast.startDate!);
        return date.year == now.year && date.month == now.month;
      }).toList();
    }
    
    return forecasts;
  }
  
  @override
  Future<List<Forecast>> getForecastsByServiceId(int serviceId, {bool useMock = true}) async {
    final forecasts = await getForecasts(useMock: useMock);
    return forecasts.where((forecast) => 
      forecast.service != null && forecast.service!.id == serviceId
    ).toList();
  }
}