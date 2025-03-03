import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class Category {
  final int? id;
  final String? name;
  final String? description;
  final String? color;

  Category({
    this.id,
    this.name,
    this.description,
    this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  factory Category.fromStrapi5Json(Map<String, dynamic> json) {
    final Map<String, dynamic> attributes = json.containsKey('attributes')
        ? json['attributes'] as Map<String, dynamic>
        : json;

    return Category(
      id: json['id'] as int?,
      name: attributes['libelle'] as String?,
      description: attributes['description'] as String?,
      color: attributes['couleur'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}