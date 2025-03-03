class Forecast {
  late String id;
  late String title;
  late String description;
  late DateTime startDate;
  late DateTime endDate;
  late String categoryName;
  late String color;

  Forecast({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.categoryName,
    required this.color,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'categoryName': categoryName,
      'color': color,
    };
  }

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      id: json['id']?.toString() ?? '',
      title: json['attributes']['libelle'] ?? '',
      description: json['attributes']['description'] ?? '',
      categoryName: '',
      color: '',
      startDate: json['attributes']['date_debut'] != null 
          ? DateTime.parse(json['attributes']['date_debut']) 
          : DateTime.now(),
      endDate: json['attributes']['date_fin'] != null 
          ? DateTime.parse(json['attributes']['date_fin']) 
          : DateTime.now(),
    );
  }

  factory Forecast.fromFlatJson(Map<String, dynamic> json) {
    return Forecast(
      id: json['id']?.toString() ?? '',
      title: json['libelle'] ?? '',
      description: json['description'] ?? '',
      categoryName: json['categorieLibelle'] ?? '',
      color: json['couleur'] ?? '',
      startDate: json['date_debut'] != null 
          ? DateTime.parse(json['date_debut']) 
          : DateTime.now(),
      endDate: json['date_fin'] != null 
          ? DateTime.parse(json['date_fin']) 
          : DateTime.now(),
    );
  }

  factory Forecast.fromNestedJson(Map<String, dynamic> json) {
    return Forecast(
      id: json['id'].toString(),
      title: json['libelle'] as String,
      description: json['description'] as String,
      startDate: DateTime.parse(json['date_debut'] as String),
      endDate: DateTime.parse(json['date_fin'] as String),
      categoryName: json['categorie']['libelle'] as String,
      color: json['couleur'] ?? "unknown",
    );
  }

  dynamic getField(String field) {
    switch (field) {
      case 'title':
        return title;
      case 'description':
        return description;
      case 'startDate':
        return startDate;
      case 'categoryName':
        return categoryName;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'Forecast{id: $id, title: $title, description: $description, startDate: $startDate, categoryName: $categoryName, color: $color}';
  }
}