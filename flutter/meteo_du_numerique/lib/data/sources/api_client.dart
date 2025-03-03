import 'dart:convert';
import 'dart:io';
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
      return [
        {
          "id": 1,
          "title": "Email Service Maintenance",
          "content": "Scheduled maintenance for email service",
          "date": "2025-03-01T10:00:00.000Z",
          "startDate": "2025-03-01T10:00:00.000Z",
          "endDate": "2025-03-01T12:00:00.000Z",
          "forecastTypeId": 1,
          "service": {
            "id": 1,
            "name": "Email Service"
          }
        },
        {
          "id": 2,
          "title": "Cloud Storage Update",
          "content": "New features coming to cloud storage",
          "date": "2025-03-05T14:00:00.000Z",
          "startDate": "2025-03-05T14:00:00.000Z",
          "endDate": "2025-03-05T18:00:00.000Z",
          "forecastTypeId": 2,
          "service": {
            "id": 2,
            "name": "Cloud Storage"
          }
        },
        {
          "id": 3,
          "title": "Authentication System Incident",
          "content": "Investigating login issues",
          "date": "2025-03-10T09:00:00.000Z",
          "startDate": "2025-03-10T09:00:00.000Z",
          "endDate": "2025-03-10T16:00:00.000Z",
          "forecastTypeId": 3,
          "service": {
            "id": 3,
            "name": "Authentication System"
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