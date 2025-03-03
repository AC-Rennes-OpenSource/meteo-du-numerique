import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../core/config/app_config.dart';
import '../models/digital_service_model.dart';
import '../models/forecast_model.dart';
import '../models/news_model.dart';

class ApiService {
  final String baseUrl = AppConfig.baseUrl;

  Future<List<News>> fetchDigitalServices() async {
    debugPrint("AppConfig.baseUrl: ${AppConfig.baseUrl}");
    debugPrint("AppConfig.urlAttributes: ${AppConfig.urlAttributes}");
    try {
      final response = await http.get(Uri.parse(baseUrl + AppConfig.urlAttributes));
      var digitalServices = _processResponse(response.body);
      return _extractNews(digitalServices);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Failed to load digital services: $e');
    }
  }

  List<DigitalService> _processResponse(String data) {
    List<dynamic> jsonData = json.decode(data);
    return jsonData.map((item) {
      return DigitalService.fromJson(item as Map<String, dynamic>);
    }).toList();
  }

  List<News> _extractNews(List<DigitalService> services) {
    List<News> allNews = [];
    for (var service in services) {
      allNews.addAll(service.news);
    }
    return allNews;
  }

  Future<List<News>> fetchMockDigitalServices() async {
    try {
      String data = await rootBundle.loadString('assets/stub.json');
      var services = _processResponse(data);
      return _extractNews(services);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw Exception('Failed to load mock services: $e');
    }
  }

  Future<List<Forecast>> fetchForecasts() async {
    final url = Uri.parse('https://qt.toutatice.fr/strapi5/api/mdn-service-numeriques?populate=*');
    
    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        throw Exception('Error retrieving data: ${response.statusCode}');
      }

      final Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['data'] == null) {
        debugPrint('No data found in response.');
        return [];
      }

      final List<dynamic> services = jsonResponse['data'];
      final List<Forecast> allForecasts = [];

      for (final service in services) {
        final String categoryName = service['mdn_categorie']?['libelle'] ?? 'Unknown';
        final String categoryColor = service['mdn_categorie']?['couleur'] ?? 'Unknown';

        final List<dynamic> forecasts = service['mdn_previsions'] ?? [];

        allForecasts.addAll(forecasts.map((forecast) {
          return Forecast(
            id: forecast['id'].toString(),
            title: forecast['libelle'] ?? 'Unknown',
            description: forecast['description'] ?? '',
            startDate: DateTime.parse(forecast['date_debut']),
            endDate: DateTime.parse(forecast['date_fin']),
            categoryName: categoryName,
            color: categoryColor,
          );
        }));
      }

      return allForecasts;
    } catch (e) {
      debugPrint('Error retrieving forecasts: $e');
      return [];
    }
  }
}