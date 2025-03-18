import 'package:meteo_du_numerique/models/qualite_de_service_model.dart';

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
