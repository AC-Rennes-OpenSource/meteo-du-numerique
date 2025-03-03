import 'package:json_annotation/json_annotation.dart';

part 'news.g.dart';

@JsonSerializable()
class News {
  final int? id;
  final String? title;
  final String? content;
  final String? date;
  final bool isUrgent;
  final bool isVisible;

  News({
    this.id,
    this.title,
    this.content,
    this.date,
    this.isUrgent = false,
    this.isVisible = true,
  });

  factory News.fromJson(Map<String, dynamic> json) => _$NewsFromJson(json);

  Map<String, dynamic> toJson() => _$NewsToJson(this);
}