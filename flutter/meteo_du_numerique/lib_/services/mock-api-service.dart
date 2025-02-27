import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class MockApiService {
  final String baseUrl = 'https://votre-api.com/api'; // URL de base de votre API Strapi

  Future<List<ServiceNumerique>> getServicesNumeriques({Map<String, dynamic>? jsonData}) async {
    if (jsonData != null) {

      return _parseServicesNumeriquesfromJson(jsonData);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/services-numeriques?populate=*'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return _parseServicesNumeriquesfromJson(jsonData);
      } else {
        throw Exception('Échec du chargement des services numériques');
      }
    } catch (e) {
      print('Erreur lors du chargement des services numériques : $e');
      rethrow;
    }
  }

  List<ServiceNumerique> _parseServicesNumeriquesfromJson(Map<String, dynamic> jsonData) {
    return (jsonData['data'] as List).map((serviceJson) {
      final attributes = serviceJson['attributes'];
      return ServiceNumerique(
        id: serviceJson['id'],
        libelle: attributes['libelle'],
        description: attributes['description'],
        lastUpdate: DateTime.parse(attributes['lastUpdate']),
        category: _parseCategory(attributes['category']['data']),
        qualiteDeService: _parseQualiteDeService(attributes['qualiteDeService']['data']),
      );
    }).toList();
  }

  Future<List<Prevision>> getPrevisions({Map<String, dynamic>? jsonData}) async {
    if (jsonData != null) {
      return _parsePrevisionsFromJson(jsonData);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/previsions?populate=*'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return _parsePrevisionsFromJson(jsonData);
      } else {
        throw Exception('Échec du chargement des prévisions');
      }
    } catch (e) {
      print('Erreur lors du chargement des prévisions : $e');
      rethrow;
    }
  }

  List<Prevision> _parsePrevisionsFromJson(Map<String, dynamic> jsonData) {
    return (jsonData['data'] as List).map((previsionJson) {
      final attributes = previsionJson['attributes'];
      return Prevision(
        id: previsionJson['id'],
        libelle: attributes['libelle'],
        description: attributes['description'],
        dateDebut: DateTime.parse(attributes['dateDebut']),
        lastUpdate: DateTime.parse(attributes['lastUpdate']),
        category: _parseCategory(attributes['category']['data']),
      );
    }).toList();
  }

  Future<List<Category>> getCategories({Map<String, dynamic>? jsonData}) async {
    if (jsonData != null) {
      return _parseCategoriesFromJson(jsonData);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/categories'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return _parseCategoriesFromJson(jsonData);
      } else {
        throw Exception('Échec du chargement des catégories');
      }
    } catch (e) {
      print('Erreur lors du chargement des catégories : $e');
      rethrow;
    }
  }

  List<Category> _parseCategoriesFromJson(Map<String, dynamic> jsonData) {
    return (jsonData['data'] as List).map((categoryJson) {
      final attributes = categoryJson['attributes'];
      return Category(
        id: categoryJson['id'],
        libelle: attributes['libelle'],
        color: attributes['color'],
      );
    }).toList();
  }

  Future<List<QualiteDeService>> getQualitesDeService({Map<String, dynamic>? jsonData}) async {
    if (jsonData != null) {
      return _parseQualitesDeServiceFromJson(jsonData);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/qualite-de-services'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return _parseQualitesDeServiceFromJson(jsonData);
      } else {
        throw Exception('Échec du chargement des qualités de service');
      }
    } catch (e) {
      print('Erreur lors du chargement des qualités de service : $e');
      rethrow;
    }
  }

  List<QualiteDeService> _parseQualitesDeServiceFromJson(Map<String, dynamic> jsonData) {
    return (jsonData['data'] as List).map((qualiteJson) {
      final attributes = qualiteJson['attributes'];
      return QualiteDeService(
        id: qualiteJson['id'],
        libelle: attributes['libelle'],
        color: attributes['color'],
      );
    }).toList();
  }

  // Méthodes utilitaires pour parser les relations
  Category? _parseCategory(Map<String, dynamic>? categoryData) {
    if (categoryData == null) return null;
    final attributes = categoryData['attributes'];
    return Category(
      id: categoryData['id'],
      libelle: attributes['libelle'],
      color: attributes['color'],
    );
  }

  QualiteDeService? _parseQualiteDeService(Map<String, dynamic>? qualiteData) {
    if (qualiteData == null) return null;
    final attributes = qualiteData['attributes'];
    return QualiteDeService(
      id: qualiteData['id'],
      libelle: attributes['libelle'],
      color: attributes['color'],
    );
  }

  // Méthodes de mise à jour (à adapter selon votre API)
  Future<void> updateServiceNumerique(ServiceNumerique service) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/services-numeriques/${service.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'data': {
            'libelle': service.libelle,
            'description': service.description,
            // Ajoutez d'autres champs à mettre à jour
          }
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Échec de la mise à jour du service');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour du service : $e');
      rethrow;
    }
  }

  Future<void> updatePrevision(Prevision prevision) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/previsions/${prevision.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'data': {
            'libelle': prevision.libelle,
            'description': prevision.description,
            // Ajoutez d'autres champs à mettre à jour
          }
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Échec de la mise à jour de la prévision');
      }
    } catch (e) {
      print('Erreur lors de la mise à jour de la prévision : $e');
      rethrow;
    }
  }
}
