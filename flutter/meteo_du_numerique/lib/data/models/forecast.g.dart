// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Forecast _$ForecastFromJson(Map<String, dynamic> json) => Forecast(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      content: json['content'] as String?,
      date: json['date'] as String?,
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      service: json['service'] == null
          ? null
          : DigitalService.fromJson(json['service'] as Map<String, dynamic>),
      forecastTypeId: (json['forecastTypeId'] as num?)?.toInt(),
      isUrgent: json['isUrgent'] as bool? ?? false,
      isVisible: json['isVisible'] as bool? ?? true,
    );

Map<String, dynamic> _$ForecastToJson(Forecast instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'date': instance.date,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'service': instance.service,
      'forecastTypeId': instance.forecastTypeId,
      'isUrgent': instance.isUrgent,
      'isVisible': instance.isVisible,
    };
