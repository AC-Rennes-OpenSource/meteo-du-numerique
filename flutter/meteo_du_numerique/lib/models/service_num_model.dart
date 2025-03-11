import 'package:meteo_du_numerique/models/qualite_de_service_model.dart';

class ServiceNum {
  late int id;
  late String libelle;
  late List<Actualite> actualites;

  ServiceNum({
    required this.id,
    required this.libelle,
    required this.actualites,
  });

  factory ServiceNum.fromJson(Map<String, dynamic> json) {
    List<Actualite> actualitesList = [Actualite.fromJson(json)];

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
      'actualites': actualites.map((a) => a.toJson()).toList(),
    };
  }

  dynamic getField(String field) {
    switch (field) {
      case 'libelle':
        return libelle;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'ServiceNum{id: $id, libelle: $libelle, actualites: $actualites}';
  }
}

class Actualite {
  late int id;
  late String libelle;
  late String description;
  late DateTime lastUpdate;
  late QualiteDeService? qualiteDeService;

  Actualite({
    required this.id,
    required this.libelle,
    required this.description,
    required this.lastUpdate,
    required this.qualiteDeService,
  });

  factory Actualite.fromJson(Map<String, dynamic> json) {
    return Actualite(
      id: json['id'] as int,
      libelle: json['libelle'] as String? ?? '',
      description: json['description'] as String? ?? '',
      lastUpdate: DateTime.parse(json['updated_at']).toLocal(),
      qualiteDeService: json['qualiteDeService'] != null ? QualiteDeService.fromJson(json['qualiteDeService'] as Map<String, dynamic>) : null,
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
