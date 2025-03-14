import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

/// Utilitaire pour charger les données de test à partir des fichiers JSON
class MockDataLoader {
  /// Charge et décode un fichier JSON depuis le répertoire des assets de test
  static Future<Map<String, dynamic>> loadJsonFromAsset(String filePath) async {
    // Chemin relatif à partir du répertoire test/
    final String fullPath = 'assets/mock_data/$filePath';

    try {
      // Essayer de charger le fichier avec rootBundle pour les tests Flutter
      final String jsonString = await rootBundle.loadString(fullPath);
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      // Si rootBundle échoue (ce qui arrive dans les tests unitaires),
      // essayer de charger directement depuis le système de fichiers
      try {
        final File file = File('test/$fullPath');
        final String jsonString = await file.readAsString();
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        throw Exception(
            'Impossible de charger le fichier de test: $fullPath. Erreur: $e');
      }
    }
  }

  /// Charge les services numériques de test
  static Future<Map<String, dynamic>> loadDigitalServices() async {
    return await loadJsonFromAsset('digital_services.json');
  }

  /// Charge les prévisions de test
  static Future<Map<String, dynamic>> loadForecasts() async {
    return await loadJsonFromAsset('forecasts.json');
  }

  /// Charge les catégories de test
  static Future<Map<String, dynamic>> loadCategories() async {
    return await loadJsonFromAsset('categories.json');
  }

  /// Charge les qualités de service de test
  static Future<Map<String, dynamic>> loadServiceQualities() async {
    return await loadJsonFromAsset('service_qualities.json');
  }
}
