import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meteo_du_numerique/services/updatable.dart';

part 'models.freezed.dart'; // Contient le code généré par Freezed
part 'models.g.dart'; // Contient les méthodes JSON (toJson/fromJson)

@freezed
class Forecast with _$Forecast implements Updatable {
  @JsonSerializable(explicitToJson: true)
  const factory Forecast({
    required String libelle,
    required String description,
    required Categorie categorie,
    required ServiceNumerique serviceNumerique,
    required QualiteService qualiteService,
    required DateTime dateDebut,
    required DateTime dateFin,
    required DateTime updatedAt,
  }) = _Forecast;

  factory Forecast.fromJson(Map<String, dynamic> json) => _$ForecastFromJson(json);
}

@freezed
class News with _$News implements Updatable {
  @JsonSerializable(explicitToJson: true)
  const factory News({
    required String libelle,
    required String description,
    required Categorie categorie,
    required ServiceNumerique serviceNumerique,
    required QualiteService qualiteService,
    required DateTime updatedAt,
  }) = _News;

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);
}

@freezed
class Categorie with _$Categorie {
  const factory Categorie({
    required String key,
    required String libelle,
    required String couleur,
  }) = _Categorie;

  factory Categorie.fromJson(Map<String, dynamic> json) => _$CategorieFromJson(json);
}

@freezed
class ServiceNumerique with _$ServiceNumerique {
  const factory ServiceNumerique({
    required String libelle,
    required String description,
    required String vignette,
  }) = _ServiceNumerique;

  factory ServiceNumerique.fromJson(Map<String, dynamic> json) => _$ServiceNumeriqueFromJson(json);
}

@freezed
class QualiteService with _$QualiteService {
  const factory QualiteService({
    required String key,
    required String libelle,
  }) = _QualiteService;

  factory QualiteService.fromJson(Map<String, dynamic> json) => _$QualiteServiceFromJson(json);
}
