// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'digital_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DigitalService _$DigitalServiceFromJson(Map<String, dynamic> json) =>
    DigitalService(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      url: json['url'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      category: json['category'] == null
          ? null
          : Category.fromJson(json['category'] as Map<String, dynamic>),
      qualityOfService: json['qualityOfService'] == null
          ? null
          : ServiceQuality.fromJson(
              json['qualityOfService'] as Map<String, dynamic>),
      isVisible: json['isVisible'] as bool? ?? true,
    );

// Added custom constructor for Strapi5 format
DigitalService _fromStrapi5Json(Map<String, dynamic> json) {
  // Extract category data or create default
  final categoryData = json['mdn_categorie'] ?? {};
  final category = Category(
    id: (categoryData['id'] as num?)?.toInt(),
    name: categoryData['libelle'] as String?,
    color: categoryData['couleur'] as String?,
  );

  // Create a default service quality for now (will be dynamically determined)
  final defaultQuality = ServiceQuality(id: 1, name: 'Fonctionnement habituel');

  return DigitalService(
    id: (json['id'] as num?)?.toInt(),
    name: json['libelle'] as String?,
    description: json['description'] as String?,
    createdAt: json['createdAt'] == null
        ? null
        : DateTime.parse(json['createdAt'] as String),
    updatedAt: json['updatedAt'] == null
        ? null
        : DateTime.parse(json['updatedAt'] as String),
    category: category,
    qualityOfService: defaultQuality,
  );
}

Map<String, dynamic> _$DigitalServiceToJson(DigitalService instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'url': instance.url,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'category': instance.category,
      'qualityOfService': instance.qualityOfService,
      'isVisible': instance.isVisible,
    };
