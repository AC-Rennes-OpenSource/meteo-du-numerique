import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// API client for making network requests
class ApiClient {
  final String baseUrl = 'https://qt.toutatice.fr/strapi5';
  final http.Client _httpClient;

  ApiClient({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  /// Makes a GET request to the specified endpoint
  Future<dynamic> get(String endpoint) async {
    try {
      final response = await _httpClient.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
      );

      return _processResponse(response);
    } catch (error) {
      debugPrint('Error during GET request: $error');
      throw Exception('Failed to connect to the server: $error');
    }
  }

  /// Makes a POST request to the specified endpoint
  Future<dynamic> post(String endpoint, dynamic body) async {
    try {
      final response = await _httpClient.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(body),
      );

      return _processResponse(response);
    } catch (error) {
      debugPrint('Error during POST request: $error');
      throw Exception('Failed to connect to the server: $error');
    }
  }

  /// Process the response from the API
  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return json.decode(response.body);
    } else {
      debugPrint('API error: ${response.statusCode}, ${response.body}');
      throw ApiException(
        statusCode: response.statusCode,
        message: 'Failed to process request: ${response.reasonPhrase}',
      );
    }
  }

  /// Returns mock data for testing or when API is unavailable
  Future<List<dynamic>> getMockData(String type) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (type == 'services') {
      try {
        // Load the strapi5-services.json file from assets bundle
        final String servicesJson = await rootBundle.loadString('assets/strapi5mock.json');
        final Map<String, dynamic> servicesData = json.decode(servicesJson);
        
        // Return the "data" array from the Strapi5 response
        if (servicesData.containsKey('data') && servicesData['data'] is List) {
          return servicesData['data'] as List<dynamic>;
        }
      } catch (e) {
        debugPrint('Error loading Strapi5 services: $e');
        // Fall back to default mock data
      }
      
      // Default mock data if file can't be loaded
      return [
        {
          "id": 1,
          "name": "Email Service",
          "description": "Corporate email service",
          "qualityOfService": {
            "id": 1,
            "name": "Operational"
          }
        },
        {
          "id": 2,
          "name": "Cloud Storage",
          "description": "Cloud storage system",
          "qualityOfService": {
            "id": 2,
            "name": "Degraded"
          }
        },
        {
          "id": 3,
          "name": "Authentication System",
          "description": "User authentication service",
          "qualityOfService": {
            "id": 3,
            "name": "Down"
          }
        }
      ];
    } else if (type == 'categories') {
      try {
        // Using the same Strapi5 mock file for categories for simplicity
        final String categoriesJson = await rootBundle.loadString('assets/strapi5mock.json');
        final Map<String, dynamic> categoriesData = json.decode(categoriesJson);
        
        // Extract categories from services to create a category list
        List<dynamic> categories = [];
        if (categoriesData.containsKey('data') && categoriesData['data'] is List) {
          final services = categoriesData['data'] as List<dynamic>;
          for (var service in services) {
            if (service.containsKey('mdn_categorie') && service['mdn_categorie'] != null) {
              final category = service['mdn_categorie'];
              if (!categories.any((c) => c['id'] == category['id'])) {
                categories.add(category);
              }
            }
          }
        }
        return categories;
      } catch (e) {
        debugPrint('Error loading Strapi5 categories: $e');
        // Fall back to default mock data
      }
    } else if (type == 'forecasts') {
      try {
        // Try to load the strapi5-previsions.json file from assets bundle 
        // or check if it exists in the docker folder
        final String forecastsJson = await rootBundle.loadString('assets/strapi5mock.json');
        final Map<String, dynamic> forecastsData = json.decode(forecastsJson);
        
        // Return the "data" array from the Strapi5 response
        if (forecastsData.containsKey('data') && forecastsData['data'] is List) {
          return forecastsData['data'] as List<dynamic>;
        }
      } catch (e) {
        debugPrint('Error loading Strapi5 forecasts: $e');
        
        // Try to load forecast data from services as fallback
        try {
          final String servicesJson = await rootBundle.loadString('assets/strapi5mock.json');
          final Map<String, dynamic> servicesData = json.decode(servicesJson);
          
          // Extract services with forecasts from the Strapi response
          List<dynamic> forecasts = [];
          if (servicesData.containsKey('data') && servicesData['data'] is List) {
            final services = servicesData['data'] as List<dynamic>;
            for (var service in services) {
              if (service.containsKey('mdn_prevision') && service['mdn_prevision'] != null) {
                // Create a forecast object with the structure of the dedicated endpoint
                final forecast = {
                  "id": service['mdn_prevision']['id'],
                  "date_debut": service['mdn_prevision']['date_debut'],
                  "date_fin": service['mdn_prevision']['date_fin'],
                  "description": service['mdn_prevision']['description'],
                  "mdn_service_numerique": {
                    "id": service['id'],
                    "libelle": service['libelle'],
                    "mdn_categorie": service['mdn_categorie']
                  },
                  "mdn_qualite_de_service_prevision": {
                    "id": 2,
                    "libelle": "perturbations",
                    "key": 2
                  }
                };
                forecasts.add(forecast);
              }
            }
            return forecasts;
          }
        } catch (e2) {
          debugPrint('Error loading service-based forecasts: $e2');
          // Fall back to default mock data
        }
      }
      
      // Default mock data if all attempts fail
      return [
        {
          "id": 1,
          "description": "Scheduled maintenance for email service",
          "date_debut": "2025-03-01T10:00:00.000Z",
          "date_fin": "2025-03-01T12:00:00.000Z",
          "mdn_qualite_de_service_prevision": {
            "id": 1,
            "libelle": "maintenance",
            "key": 1
          },
          "mdn_service_numerique": {
            "id": 1,
            "libelle": "Email Service",
            "mdn_categorie": {
              "id": 1,
              "libelle": "Communication",
              "couleur": "0xFF795548"
            }
          }
        },
        {
          "id": 2,
          "description": "New features coming to cloud storage",
          "date_debut": "2025-03-05T14:00:00.000Z",
          "date_fin": "2025-03-05T18:00:00.000Z",
          "mdn_qualite_de_service_prevision": {
            "id": 2,
            "libelle": "perturbations",
            "key": 2
          },
          "mdn_service_numerique": {
            "id": 2,
            "libelle": "Cloud Storage",
            "mdn_categorie": {
              "id": 2,
              "libelle": "Collaboration",
              "couleur": "0xff63BAAB"
            }
          }
        },
        {
          "id": 3,
          "description": "Investigating login issues",
          "date_debut": "2025-03-10T09:00:00.000Z",
          "date_fin": "2025-03-10T16:00:00.000Z",
          "mdn_qualite_de_service_prevision": {
            "id": 3,
            "libelle": "incident",
            "key": 3
          },
          "mdn_service_numerique": {
            "id": 3,
            "libelle": "Authentication System",
            "mdn_categorie": {
              "id": 3,
              "libelle": "Scolarité",
              "couleur": "0xff00B872"
            }
          }
        }
      ];
    }
    
    return [];
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final int statusCode;
  final String message;

  ApiException({required this.statusCode, required this.message});

  @override
  String toString() => 'ApiException: $statusCode - $message';
}