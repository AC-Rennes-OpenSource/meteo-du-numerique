import 'models.dart';

class ApiMapper {
  /// Mapper pour convertir la réponse API en liste de prévisions
  List<Forecast> parseForecastsFromApiResponse(Map<String, dynamic> apiResponse) {
    return (apiResponse['data'] as List).map((data) {
      return Forecast(
        libelle: data['libelle'],
        description: data['mdn_prevision']?['description'] ?? '',
        categorie: Categorie(
          key: data['mdn_categorie']['id'].toString(),
          libelle: data['mdn_categorie']['libelle'],
          couleur: data['mdn_categorie']['couleur'],
        ),
        serviceNumerique: ServiceNumerique(
          libelle: data['libelle'],
          description: data['mdn_prevision']?['description'] ?? '',
          vignette: data['vignette'] ?? '',
        ),
        qualiteService: QualiteService(
          key: data['id'].toString(),
          libelle: "Qualité non spécifiée", // Ajustez si nécessaire
        ),
        dateDebut: DateTime.parse(data['mdn_prevision']?['date_debut'] ?? DateTime.now().toIso8601String()),
        dateFin: DateTime.parse(data['mdn_prevision']?['date_fin'] ?? DateTime.now().toIso8601String()),
        updatedAt: DateTime.parse(data['mdn_prevision']?['updatedAt'] ?? DateTime.now().toIso8601String()),
      );
    }).toList();
  }

  /// Mapper pour convertir la réponse API en liste d'actualités
  List<News> parseNewsFromApiResponse(Map<String, dynamic> apiResponse) {
    return (apiResponse['data'] as List).map((data) {
      return News(
        libelle: data['libelle'],
        description: data['mdn_actualite']?['description'] ?? '',
        categorie: Categorie(
          key: data['mdn_categorie']['id'].toString(),
          libelle: data['mdn_categorie']['libelle'],
          couleur: data['mdn_categorie']['couleur'],
        ),
        serviceNumerique: ServiceNumerique(
          libelle: data['libelle'],
          description: data['description'],
          vignette: data['vignette'] ?? '',
        ),
        qualiteService: QualiteService(
          key: data['id'].toString(),
          libelle: "Qualité non spécifiée", // Ajustez si nécessaire
        ),
        updatedAt: DateTime.parse(data['mdn_actualite']?['updatedAt'] ?? DateTime.now().toIso8601String()),
      );
    }).toList();
  }
}
