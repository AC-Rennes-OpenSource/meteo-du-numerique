import 'service_quality_model.dart';

class News {
  late int id;
  late String title;
  late String description;
  late DateTime lastUpdate;
  late ServiceQuality? serviceQuality;

  News({
    required this.id,
    required this.title,
    required this.description,
    required this.lastUpdate,
    required this.serviceQuality,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      id: json['id'] as int,
      title: json['libelle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      lastUpdate: DateTime.parse(json['updated_at']).toLocal(),
      serviceQuality: json['qualiteDeService'] != null
          ? ServiceQuality.fromJson(json['qualiteDeService'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'serviceQuality': serviceQuality,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  dynamic getField(String field) {
    switch (field) {
      case 'title':
        return title;
      case 'description':
        return description;
      case 'lastUpdate':
        return lastUpdate;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'News{id: $id, title: $title, description: $description, lastUpdate: $lastUpdate, serviceQuality: $serviceQuality}';
  }
}