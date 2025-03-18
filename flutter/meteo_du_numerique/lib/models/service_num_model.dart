import 'actualite_model.dart';

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
    // Mapper les actualités (si applicable)
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
