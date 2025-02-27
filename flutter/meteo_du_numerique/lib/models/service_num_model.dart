import 'package:meteo_du_numerique/models/qualite_de_service_model.dart';

class ServiceNum {
  late int id;
  late String libelle;
  late List<ActualiteA> actualites;

  ServiceNum({
    required this.id,
    required this.libelle,
    required this.actualites,
  });

  factory ServiceNum.fromJson(Map<String, dynamic> json) {
    // Mapper les actualités (si applicable)
    List<ActualiteA> actualitesList = [ActualiteA.fromJson(json)];

    return ServiceNum(
      id: json['id'] as int,
      libelle: json['libelle'] as String? ?? '',
      actualites: actualitesList,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
      // 'category': category.toJson(),
      'actualites': actualites.map((a) => a.toJson()).toList(),
      // 'previsions': previsions.map((p) => p.toJson()).toList(),
    };
  }

  dynamic getField(String field) {
    switch (field) {
      case 'libelle':
        return libelle;
      // case 'category':
      //   return category;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'ServiceNum{id: $id, libelle: $libelle, '
        // 'category: $category, '
        'actualites: $actualites, '
        // 'previsions: $previsions'
        '}';
  }
}

// todo-----------------------------------------------------------------

class PrevisionA {
  late String id;
  late String libelle;
  late String description;
  late DateTime dateDebut;
  late DateTime dateFin;
  late String categorieLibelle;
  late String couleur;

  PrevisionA({
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

  factory PrevisionA.fromJson(Map<String, dynamic> json) {
    var prev = PrevisionA(
      id: json['id']?.toString() ?? '',
      libelle: json['attributes']['libelle'] ?? '',
      description: json['attributes']['description'] ?? '',
      categorieLibelle: '',
      couleur: '',
      dateDebut:
          json['attributes']['date_debut'] != null ? DateTime.parse(json['attributes']['date_debut']) : DateTime.now(),
      dateFin:
          json['attributes']['date_fin'] != null ? DateTime.parse(json['attributes']['date_fin']) : DateTime.now(),
    );
    return prev;
  }

  factory PrevisionA.fromJson1(Map<String, dynamic> json) {
    var prev = PrevisionA(
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
      dateDebut:
      json['date_debut'] != null ? DateTime.parse(json['date_debut']) : DateTime.now(),
      dateFin:
      json['date_fin'] != null ? DateTime.parse(json['date_fin']) : DateTime.now(),
    );
    return prev;
  }

  factory PrevisionA.fromJson2(Map<String, dynamic> json) {
    return PrevisionA(
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

// todo-----------------------------------------------------------------

class ActualiteA {
  late int id;
  late String libelle;
  late String description;
  late DateTime lastUpdate;
  late QualiteDeService? qualiteDeService;

  ActualiteA({
    required this.id,
    required this.libelle,
    required this.description,
    required this.lastUpdate,
    required this.qualiteDeService,
  });

  factory ActualiteA.fromJson(Map<String, dynamic> json) {
    return ActualiteA(
      id: json['id'] as int,
      libelle: json['libelle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      lastUpdate: DateTime.parse(json['updated_at']).toLocal(),
      qualiteDeService: json['qualiteDeService'] != null
          ? QualiteDeService.fromJson(json['qualiteDeService'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
      'description': description,
      'qualiteDeService': qualiteDeService,
      'lastUpdate': lastUpdate.toIso8601String(),
    };
  }

  dynamic getField(String field) {
    switch (field) {
      case 'libelle':
        return libelle;
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
    return 'ActualiteA{id: $id, libelle: $libelle, description: $description, lastUpdate: $lastUpdate, qualiteDeService: $qualiteDeService}';
  }
}
