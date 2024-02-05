import 'package:meteo_du_numerique/models/qualite_de_service_model.dart';

import 'categorie_model.dart';

class ServiceNum {
  late int id;
  late String libelle;
  late Categorie category;
  late List<ActualiteA> actualites;
  late List<PrevisionA> previsions;

  ServiceNum({
    required this.id,
    required this.libelle,
    required this.category,
    required this.actualites,
    required this.previsions,
  });

  factory ServiceNum.fromJson(Map<String, dynamic> json) {
    var previsionslist = json['attributes']['previsions']['data'] as List;
    List<PrevisionA> previsionsList = previsionslist.map((i) => PrevisionA.fromJson(i)).toList();
    var actualiteslist = json['attributes']['actualites']['data'] as List;
    List<ActualiteA> actualitesList = actualiteslist.map((i) => ActualiteA.fromJson(i)).toList();

    return ServiceNum(
      id: json['id'],
      previsions: previsionsList,
      actualites: actualitesList,
      libelle: json['attributes']['libelle'] ?? '',
      category: Categorie.fromJson(json['attributes']['categorie']['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
      'category': category.toJson(), // Assurez-vous que Categorie a une méthode toJson()
      'actualites': actualites.map((a) => a.toJson()).toList(),
      'previsions': previsions.map((p) => p.toJson()).toList(),
    };
  }

  dynamic getField(String field) {
    switch (field) {
      case 'libelle':
        return libelle;
      case 'category':
        return category;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'ServiceNum{id: $id, libelle: $libelle, category: $category, actualites: $actualites, previsions: $previsions}';
  }
}

// todo-----------------------------------------------------------------

class PrevisionA {
  late String id;
  late String libelle;
  late String description;
  late DateTime dateDebut;
  late String categorieLibelle;
  late String couleur;

  PrevisionA({
    required this.id,
    required this.libelle,
    required this.description,
    required this.dateDebut,
    required this.categorieLibelle,
    required this.couleur,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
      'description': description,
      'dateDebut': dateDebut.toIso8601String(),
      'categorieLibelle': categorieLibelle,
      'couleur': couleur,
    };
  }

  factory PrevisionA.fromJson(Map<String, dynamic> json) {
    return PrevisionA(
      id: json['id']?.toString() ?? '',
      libelle: json['attributes']['libelle'] ?? '',
      description: json['attributes']['description'] ?? '',
      categorieLibelle: '',
      couleur: '',
      dateDebut:
      json['attributes']['date_debut'] != null ? DateTime.parse(json['attributes']['date_debut']) : DateTime.now(),
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
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'PrevisionA{id: $id, libelle: $libelle, description: $description, dateDebut: $dateDebut}';
  }
}

// todo-----------------------------------------------------------------

class ActualiteA {
  late String id;
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
    var qualiteDeServiceJson = json['attributes']['qualite_de_service']['data'];
    var qualiteDeService = qualiteDeServiceJson != null
        ? QualiteDeService.fromJson(qualiteDeServiceJson)
        : null;

    return ActualiteA(
      id: json['id']?.toString() ?? '',
      libelle: json['attributes']['libelle'] ?? '',
      description: json['attributes']['description'] ?? '',
      qualiteDeService: qualiteDeService,
      lastUpdate:
      json['attributes']['updatedAt'] != null ? DateTime.parse(json['attributes']['updatedAt']) : DateTime.now(),
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


