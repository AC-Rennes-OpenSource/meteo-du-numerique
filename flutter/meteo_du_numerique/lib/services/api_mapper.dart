import 'package:flutter/cupertino.dart';

import 'models.dart';

class ApiMapper {
  /// Mapper pour convertir la réponse API en liste de prévisions
  List<Forecast> parseForecastsFromApiResponse(Map<String, dynamic> apiResponse) {
    try {
      final forecastsList = <Forecast>[];

      // Afficher la structure pour déboguer
      debugPrint('Structure de la réponse des prévisions: ${apiResponse.keys}');
      if (apiResponse['data'] is List && (apiResponse['data'] as List).isNotEmpty) {
        debugPrint('Premier élément de prévision: ${(apiResponse['data'] as List)[0].keys}');

        var first = (apiResponse['data'] as List)[0];
        if (first['attributes'] != null) {
          debugPrint('Attributs du premier élément: ${first['attributes'].keys}');
        }
      }

      for (var data in apiResponse['data'] as List) {
        try {
          var attributes = data['attributes'];
          if (attributes == null) {
            debugPrint('Attributs manquants pour la prévision ID: ${data['id']}');
            continue;
          }

          // Données par défaut pour les champs obligatoires
          var categorieData = {};
          if (attributes['mdn_categorie'] != null &&
              attributes['mdn_categorie']['data'] != null &&
              attributes['mdn_categorie']['data']['attributes'] != null) {
            categorieData = attributes['mdn_categorie']['data']['attributes'];
          }

          // Valeurs par défaut
          var description = attributes['description'] ?? '';
          var dateDebut = DateTime.now();
          var dateFin = DateTime.now().add(Duration(days: 7));
          var updatedAt = DateTime.now();

          // Si on a des données de prévision, on les utilise
          if (attributes['mdn_prevision'] != null &&
              attributes['mdn_prevision']['data'] != null &&
              attributes['mdn_prevision']['data']['attributes'] != null) {
            var previsionData = attributes['mdn_prevision']['data']['attributes'];
            description = previsionData['description'] ?? description;

            if (previsionData['date_debut'] != null) {
              dateDebut = DateTime.tryParse(previsionData['date_debut']) ?? dateDebut;
            }

            if (previsionData['date_fin'] != null) {
              dateFin = DateTime.tryParse(previsionData['date_fin']) ?? dateFin;
            }

            if (previsionData['updatedAt'] != null) {
              updatedAt = DateTime.tryParse(previsionData['updatedAt']) ?? updatedAt;
            }
          } else if (attributes['updatedAt'] != null) {
            updatedAt = DateTime.tryParse(attributes['updatedAt']) ?? updatedAt;
          }

          forecastsList.add(Forecast(
            libelle: attributes['libelle'] ?? 'Sans titre',
            description: description,
            categorie: Categorie(
              key: categorieData['id'] != null ? categorieData['id'].toString() : '0',
              libelle: categorieData['libelle'] ?? 'Non catégorisé',
              couleur: categorieData['couleur'] ?? '#CCCCCC',
            ),
            serviceNumerique: ServiceNumerique(
              libelle: attributes['libelle'] ?? 'Sans titre',
              description: description,
              vignette: attributes['vignette'] ?? '',
            ),
            qualiteService: QualiteService(
              key: data['id'].toString(),
              libelle: "Qualité ${(data['id'] as int) % 4}",
            ),
            dateDebut: dateDebut,
            dateFin: dateFin,
            updatedAt: updatedAt,
          ));
        } catch (e) {
          debugPrint('Erreur lors du parsing d\'une prévision individuelle: $e');
        }
      }

      debugPrint('Nombre de prévisions créées: ${forecastsList.length}');
      return forecastsList;
    } catch (e) {
      debugPrint('Erreur lors du parsing des prévisions: $e');
      return [];
    }
  }

  /// Mapper pour convertir la réponse API en liste d'actualités
  List<News> parseNewsFromApiResponse(Map<String, dynamic> apiResponse) {
    try {
      final newsList = <News>[];

      // Afficher la structure pour déboguer
      debugPrint('Structure de la réponse: ${apiResponse.keys}');
      if (apiResponse['data'] is List && (apiResponse['data'] as List).isNotEmpty) {
        debugPrint('Premier élément: ${(apiResponse['data'] as List)[0].keys}');
      }

      for (var data in apiResponse['data'] as List) {
        try {
          var attributes = data['attributes'];
          if (attributes == null) {
            debugPrint('Attributs manquants pour l\'élément ID: ${data['id']}');
            continue;
          }

          // Créer une actualité même sans mdn_actualite (en utilisant les données de base)
          // Cela nous permettra d'avoir au moins quelque chose à afficher
          var categorieData = {};
          if (attributes['mdn_categorie'] != null &&
              attributes['mdn_categorie']['data'] != null &&
              attributes['mdn_categorie']['data']['attributes'] != null) {
            categorieData = attributes['mdn_categorie']['data']['attributes'];
          }

          var description = '';
          var updatedAt = DateTime.now();

          // Si on a des données d'actualité, on les utilise
          if (attributes['mdn_actualite'] != null &&
              attributes['mdn_actualite']['data'] != null &&
              attributes['mdn_actualite']['data']['attributes'] != null) {
            var actualiteData = attributes['mdn_actualite']['data']['attributes'];
            description = actualiteData['description'] ?? '';
            if (actualiteData['updatedAt'] != null) {
              updatedAt = DateTime.tryParse(actualiteData['updatedAt']) ?? DateTime.now();
            }
          } else {
            // Sinon on utilise la description du service
            description = attributes['description'] ?? '';
            if (attributes['updatedAt'] != null) {
              updatedAt = DateTime.tryParse(attributes['updatedAt']) ?? DateTime.now();
            }
          }

          newsList.add(News(
            libelle: attributes['libelle'] ?? 'Sans titre',
            description: description,
            categorie: Categorie(
              key: categorieData['id'] != null ? categorieData['id'].toString() : '0',
              libelle: categorieData['libelle'] ?? 'Non catégorisé',
              couleur: categorieData['couleur'] ?? '#CCCCCC',
            ),
            serviceNumerique: ServiceNumerique(
              libelle: attributes['libelle'] ?? 'Sans titre',
              description: attributes['description'] ?? '',
              vignette: attributes['vignette'] ?? '',
            ),
            qualiteService: QualiteService(
              key: data['id'].toString(),
              libelle: "Qualité ${(data['id'] as int) % 4}",
            ),
            updatedAt: updatedAt,
          ));
        } catch (e) {
          debugPrint('Erreur lors du parsing d\'une actualité individuelle: $e');
        }
      }

      debugPrint('Nombre d\'actualités créées: ${newsList.length}');
      return newsList;
    } catch (e) {
      debugPrint('Erreur lors du parsing des actualités: $e');
      return [];
    }
  }
}
