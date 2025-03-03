import 'package:json_annotation/json_annotation.dart';

part 'service_quality.g.dart';

@JsonSerializable()
class ServiceQuality {
  final int? id;
  final String? name;
  final String? description;
  final String? color;

  ServiceQuality({
    this.id,
    this.name,
    this.description,
    this.color,
  });

  factory ServiceQuality.fromJson(Map<String, dynamic> json) => _$ServiceQualityFromJson(json);

  Map<String, dynamic> toJson() => _$ServiceQualityToJson(this);
}