class Categorie {
  late String id;
  late String libelle;
  late String color;

  Categorie({required this.id, required this.libelle, required this.color});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['id']?.toString() ?? '',
      libelle: json['attributes']['libelle'] ?? '',
      color: json['attributes']['couleur'] ?? '',
    );
  }

  dynamic getField(String field) {
    switch (field) {
      case 'libelle':
        return libelle;
      case 'color':
        return color;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'Categorie{id: $id, libelle: $libelle, color: $color}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
      'color': color,
    };
  }
}
