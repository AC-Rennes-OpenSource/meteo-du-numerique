class Category {
  late String id;
  late String name;
  late String color;

  Category({required this.id, required this.name, required this.color});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id']?.toString() ?? '',
      name: json['attributes']['libelle'] ?? '',
      color: json['attributes']['couleur'] ?? '',
    );
  }

  dynamic getField(String field) {
    switch (field) {
      case 'name':
        return name;
      case 'color':
        return color;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'Category{id: $id, name: $name, color: $color}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color,
    };
  }
}