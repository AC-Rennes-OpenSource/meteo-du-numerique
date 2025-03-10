import 'package:json_annotation/json_annotation.dart';
import 'digital_service.dart';
import 'category.dart';

part 'forecast.g.dart';

@JsonSerializable()
class Forecast {
  final int? id;
  final String? title;
  final String? content;
  final String? date;
  final String? startDate;
  final String? endDate;
  final DigitalService? service;
  final int? forecastTypeId;
  final String? forecastTypeName;
  final bool isUrgent;
  final bool isVisible;

  Forecast({
    this.id,
    this.title,
    this.content,
    this.date,
    this.startDate,
    this.endDate,
    this.service,
    this.forecastTypeId,
    this.forecastTypeName,
    this.isUrgent = false,
    this.isVisible = true,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) => _$ForecastFromJson(json);

  // Custom factory for Strapi5 format, for the direct previsions endpoint
  factory Forecast.fromStrapi5Json(Map<String, dynamic> json) {
    // Extract service data
    final serviceData = json['mdn_service_numerique'] ?? {};
    
    // Extract category data from service
    Category? category;
    if (serviceData['mdn_categorie'] != null) {
      category = Category(
        id: (serviceData['mdn_categorie']['id'] as num?)?.toInt(),
        name: serviceData['mdn_categorie']['libelle'] as String?,
        color: serviceData['mdn_categorie']['couleur'] as String?,
      );
    }
    
    // Create service object
    final service = DigitalService(
      id: (serviceData['id'] as num?)?.toInt(),
      name: serviceData['libelle'] as String?,
      category: category,
    );

    // Extract forecast type data
    int? typeId;
    String? typeName;
    int? typeKey;
    if (json['mdn_qualite_de_service_prevision'] != null) {
      typeId = (json['mdn_qualite_de_service_prevision']['id'] as num?)?.toInt();
      typeName = json['mdn_qualite_de_service_prevision']['libelle'] as String?;
      typeKey = (json['mdn_qualite_de_service_prevision']['key'] as num?)?.toInt();
      
      // If typeId is null but we have a key, use that as the id
      typeId ??= typeKey;
    }

    return Forecast(
      id: (json['id'] as num?)?.toInt(),
      title: json['libelle'] != null ? "${json['libelle']}" : null,
      // Supposons que libelle existera bientôt dans l'API
      content: json['description'] != null ? "${json['description']}" : null,
      date: null, // No direct date field in sample
      startDate: json['date_debut'] as String?,
      endDate: json['date_fin'] as String?,
      service: service,
      forecastTypeId: typeKey,
      forecastTypeName: typeName,
      isUrgent: false, // Default value
      isVisible: true, // Default value
    );
  }
  
  // Factory to extract forecast data from inside service object
  factory Forecast.fromStrapi5ServiceJson(Map<String, dynamic> json) {
    // Check if there's a preview object within the service json
    final previewData = json['mdn_prevision'];
    if (previewData == null) return Forecast();
    
    // Extract category data
    Category? category;
    if (json['mdn_categorie'] != null) {
      category = Category(
        id: (json['mdn_categorie']['id'] as num?)?.toInt(), 
        name: json['mdn_categorie']['libelle'] as String?,
        color: json['mdn_categorie']['couleur'] as String?,
      );
    }
    
    // Extract service data from parent json
    final service = DigitalService(
      id: (json['id'] as num?)?.toInt(),
      name: json['libelle'] as String?,
      category: category,
    );

    return Forecast(
      id: (previewData['id'] as num?)?.toInt(),
      title: json['libelle'] != null ? "${json['libelle']} - Prévision" : null,
      // Supposons que libelle existera bientôt dans l'API
      content: previewData['libelle'] != null 
          ? "${previewData['libelle']}\n\n${previewData['description'] ?? ''}"
          : previewData['description'] as String?,
      date: null, // No direct date field in sample
      startDate: previewData['date_debut'] as String?,
      endDate: previewData['date_fin'] as String?,
      service: service,
      forecastTypeId: 2, // Default value based on sample data
      forecastTypeName: "perturbations", // Default value based on sample data
      isUrgent: false, // Default values as not in sample
      isVisible: true,
    );
  }

  Map<String, dynamic> toJson() => _$ForecastToJson(this);
}