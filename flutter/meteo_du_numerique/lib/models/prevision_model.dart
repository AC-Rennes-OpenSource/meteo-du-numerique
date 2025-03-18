class Prevision {
  late String id;
  late String libelle;
  late String description;
  late DateTime dateDebut;
  late DateTime dateFin;
  late String categorieLibelle;
  late String couleur;

  Prevision({
    required this.id,
    required this.libelle,
    required this.description,
    required this.dateDebut,
    required this.dateFin,
    required this.categorieLibelle,
    required this.couleur,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
      'description': description,
      'dateDebut': dateDebut.toIso8601String(),
      'dateFin': dateFin.toIso8601String(),
      'categorieLibelle': categorieLibelle,
      'couleur': couleur,
    };
  }

  factory Prevision.fromJson(Map<String, dynamic> json) {
    var prev = Prevision(
      id: json['id']?.toString() ?? '',
      libelle: json['attributes']['libelle'] ?? '',
      description: json['attributes']['description'] ?? '',
      categorieLibelle: '',
      couleur: '',
      dateDebut: json['attributes']['date_debut'] != null ? DateTime.parse(json['attributes']['date_debut']) : DateTime.now(),
      dateFin: json['attributes']['date_fin'] != null ? DateTime.parse(json['attributes']['date_fin']) : DateTime.now(),
    );
    return prev;
  }

  factory Prevision.fromJson1(Map<String, dynamic> json) {
    var prev = Prevision(
      id: json['id']?.toString() ?? '',
      // libelle: json['attributes']['libelle'] ?? '',
      libelle: json['libelle'] ?? '',
      // description: json['attributes']['description'] ?? '',
      description: json['description'] ?? '',
      // categorieLibelle: '',
      categorieLibelle: json['categorieLibelle'] ?? '',
      // couleur: '',
      couleur: json['couleur'] ?? '',
      // dateDebut:
      //     json['attributes']['date_debut'] != null ? DateTime.parse(json['attributes']['date_debut']) : DateTime.now(),
      dateDebut: json['date_debut'] != null ? DateTime.parse(json['date_debut']) : DateTime.now(),
      dateFin: json['date_fin'] != null ? DateTime.parse(json['date_fin']) : DateTime.now(),
    );
    return prev;
  }

  factory Prevision.fromJson2(Map<String, dynamic> json) {
    return Prevision(
      id: json['id'].toString(),
      libelle: json['libelle'] as String,
      description: json['description'] as String,
      dateDebut: DateTime.parse(json['date_debut'] as String),
      dateFin: DateTime.parse(json['date_fin'] as String),
      categorieLibelle: json['categorie']['libelle'] as String,
      couleur: json['couleur'] ?? "inconnu", // Valeur par défaut pour `couleur`
    );
  }

  dynamic getField(String field) {
    switch (field) {
      case 'libelle':
        return libelle;
      case 'description':
        return description;
      case 'dateDebut':
        return dateDebut;
      case 'categorieLibelle':
        return categorieLibelle;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'PrevisionA{id: $id, libelle: $libelle, description: $description, dateDebut: $dateDebut, categorieLibelle: $categorieLibelle, couleur: $couleur}';
  }
}