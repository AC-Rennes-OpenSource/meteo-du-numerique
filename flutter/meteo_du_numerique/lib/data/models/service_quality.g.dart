// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_quality.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceQuality _$ServiceQualityFromJson(Map<String, dynamic> json) =>
    ServiceQuality(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$ServiceQualityToJson(ServiceQuality instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'color': instance.color,
    };
