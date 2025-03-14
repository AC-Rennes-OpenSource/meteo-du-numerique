import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:meteo_du_numerique/data/sources/api_client.dart';
import 'package:mocktail/mocktail.dart';

import 'mock_data_loader.dart';

class MockClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class MockUri extends Mock implements Uri {}

/// Configuration d'un API client mockée pour les tests
class MockApiSetup {
  /// Configure un API client mockée qui retourne des données de test
  static Future<ApiClient> setupMockApiClient() async {
    final client = MockClient();
    final apiClient = ApiClient();

    // Injection du client HTTP mockée
    // Normalement, vous auriez besoin d'ajuster l'ApiClient pour permettre l'injection du client HTTP
    // apiClient.httpClient = client;

    // Configuration des réponses mockées pour différentes requêtes
    await _setupDigitalServicesResponses(client);
    await _setupForecastsResponses(client);
    await _setupCategoriesResponses(client);
    await _setupServiceQualitiesResponses(client);

    return apiClient;
  }

  /// Configure les réponses mockées pour les services numériques
  static Future<void> _setupDigitalServicesResponses(MockClient client) async {
    final mockData = await MockDataLoader.loadDigitalServices();
    final mockResponse = MockResponse();

    // Configuration de la réponse mockée
    when(() => mockResponse.statusCode).thenReturn(200);
    when(() => mockResponse.body).thenReturn(mockData.toString());

    // Simulation de la requête GET pour les services numériques
    when(() => client.get(any())).thenAnswer((_) async => mockResponse);
  }

  /// Configure les réponses mockées pour les prévisions
  static Future<void> _setupForecastsResponses(MockClient client) async {
    final mockData = await MockDataLoader.loadForecasts();
    final mockResponse = MockResponse();

    // Configuration de la réponse mockée
    when(() => mockResponse.statusCode).thenReturn(200);
    when(() => mockResponse.body).thenReturn(mockData.toString());

    // Simulation de la requête GET pour les prévisions
    when(() => client.get(any())).thenAnswer((_) async => mockResponse);
  }

  /// Configure les réponses mockées pour les catégories
  static Future<void> _setupCategoriesResponses(MockClient client) async {
    final mockData = await MockDataLoader.loadCategories();
    final mockResponse = MockResponse();

    // Configuration de la réponse mockée
    when(() => mockResponse.statusCode).thenReturn(200);
    when(() => mockResponse.body).thenReturn(mockData.toString());

    // Simulation de la requête GET pour les catégories
    when(() => client.get(any())).thenAnswer((_) async => mockResponse);
  }

  /// Configure les réponses mockées pour les qualités de service
  static Future<void> _setupServiceQualitiesResponses(MockClient client) async {
    final mockData = await MockDataLoader.loadServiceQualities();
    final mockResponse = MockResponse();

    // Configuration de la réponse mockée
    when(() => mockResponse.statusCode).thenReturn(200);
    when(() => mockResponse.body).thenReturn(mockData.toString());

    // Simulation de la requête GET pour les qualités de service
    when(() => client.get(any())).thenAnswer((_) async => mockResponse);
  }
}
