import 'news_model.dart';

class DigitalService {
  late int id;
  late String name;
  late List<News> news;

  DigitalService({
    required this.id,
    required this.name,
    required this.news,
  });

  factory DigitalService.fromJson(Map<String, dynamic> json) {
    // Map news if available
    List<News> newsList = [News.fromJson(json)];

    return DigitalService(
      id: json['id'] as int,
      name: json['libelle'] as String? ?? '',
      news: newsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'news': news.map((n) => n.toJson()).toList(),
    };
  }

  dynamic getField(String field) {
    switch (field) {
      case 'name':
        return name;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'DigitalService{id: $id, name: $name, news: $news}';
  }
}