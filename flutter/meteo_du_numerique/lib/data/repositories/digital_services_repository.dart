import '../models/digital_service.dart';
import '../sources/api_client.dart';

/// Repository interface for digital services
abstract class DigitalServicesRepository {
  /// Get a list of all digital services
  Future<List<DigitalService>> getDigitalServices({bool useMock = true});
  
  /// Get a specific digital service by ID
  Future<DigitalService?> getDigitalServiceById(int id, {bool useMock = true});
}

/// Implementation of DigitalServicesRepository
class DigitalServicesRepositoryImpl implements DigitalServicesRepository {
  final ApiClient _apiClient;
  
  DigitalServicesRepositoryImpl(this._apiClient);
  
  @override
  Future<List<DigitalService>> getDigitalServices({bool useMock = true}) async {
    try {
      List<dynamic> data = [];
      
      if (useMock) {
        data = await _apiClient.getMockData('services');
      } else {
        final response = await _apiClient.get('api/mdn-service-numeriques?populate=*');
        
        // Check if response is in Strapi format with data array
        if (response is Map<String, dynamic> && response.containsKey('data')) {
          data = response['data'] as List<dynamic>;
        } else {
          throw Exception('Unexpected API response format');
        }
      }
      
      // Use the Strapi5 JSON format parser
      return data.map((json) => DigitalService.fromStrapi5Json(json)).toList();
    } catch (e) {
      throw Exception('Failed to load digital services: $e');
    }
  }
  
  @override
  Future<DigitalService?> getDigitalServiceById(int id, {bool useMock = true}) async {
    try {
      final services = await getDigitalServices(useMock: useMock);
      return services.firstWhere((service) => service.id == id);
    } catch (e) {
      throw Exception('Failed to find digital service with ID $id: $e');
    }
  }
}