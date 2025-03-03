import 'package:json_annotation/json_annotation.dart';
import 'digital_service.dart';

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
    this.isUrgent = false,
    this.isVisible = true,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) => _$ForecastFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastToJson(this);
}