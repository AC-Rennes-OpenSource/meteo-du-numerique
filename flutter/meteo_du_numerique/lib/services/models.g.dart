// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ForecastImpl _$$ForecastImplFromJson(Map<String, dynamic> json) => _$ForecastImpl(
      libelle: json['libelle'] as String,
      description: json['description'] as String,
      categorie: Categorie.fromJson(json['categorie'] as Map<String, dynamic>),
      serviceNumerique: ServiceNumerique.fromJson(json['serviceNumerique'] as Map<String, dynamic>),
      qualiteService: QualiteService.fromJson(json['qualiteService'] as Map<String, dynamic>),
      dateDebut: DateTime.parse(json['dateDebut'] as String),
      dateFin: DateTime.parse(json['dateFin'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ForecastImplToJson(_$ForecastImpl instance) => <String, dynamic>{
      'libelle': instance.libelle,
      'description': instance.description,
      'categorie': instance.categorie.toJson(),
      'serviceNumerique': instance.serviceNumerique.toJson(),
      'qualiteService': instance.qualiteService.toJson(),
      'dateDebut': instance.dateDebut.toIso8601String(),
      'dateFin': instance.dateFin.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$NewsImpl _$$NewsImplFromJson(Map<String, dynamic> json) => _$NewsImpl(
      libelle: json['libelle'] as String,
      description: json['description'] as String,
      categorie: Categorie.fromJson(json['categorie'] as Map<String, dynamic>),
      serviceNumerique: ServiceNumerique.fromJson(json['serviceNumerique'] as Map<String, dynamic>),
      qualiteService: QualiteService.fromJson(json['qualiteService'] as Map<String, dynamic>),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$NewsImplToJson(_$NewsImpl instance) => <String, dynamic>{
      'libelle': instance.libelle,
      'description': instance.description,
      'categorie': instance.categorie.toJson(),
      'serviceNumerique': instance.serviceNumerique.toJson(),
      'qualiteService': instance.qualiteService.toJson(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$CategorieImpl _$$CategorieImplFromJson(Map<String, dynamic> json) => _$CategorieImpl(
      key: json['key'] as String,
      libelle: json['libelle'] as String,
      couleur: json['couleur'] as String,
    );

Map<String, dynamic> _$$CategorieImplToJson(_$CategorieImpl instance) => <String, dynamic>{
      'key': instance.key,
      'libelle': instance.libelle,
      'couleur': instance.couleur,
    };

_$ServiceNumeriqueImpl _$$ServiceNumeriqueImplFromJson(Map<String, dynamic> json) => _$ServiceNumeriqueImpl(
      libelle: json['libelle'] as String,
      description: json['description'] as String,
      vignette: json['vignette'] as String,
    );

Map<String, dynamic> _$$ServiceNumeriqueImplToJson(_$ServiceNumeriqueImpl instance) => <String, dynamic>{
      'libelle': instance.libelle,
      'description': instance.description,
      'vignette': instance.vignette,
    };

_$QualiteServiceImpl _$$QualiteServiceImplFromJson(Map<String, dynamic> json) => _$QualiteServiceImpl(
      key: json['key'] as String,
      libelle: json['libelle'] as String,
    );

Map<String, dynamic> _$$QualiteServiceImplToJson(_$QualiteServiceImpl instance) => <String, dynamic>{
      'key': instance.key,
      'libelle': instance.libelle,
    };
