class QualiteDeService {
  late int id;
  late String couleur;
  late String libelle;

  QualiteDeService({
    required this.id,
    required this.couleur,
    required this.libelle,
  });

  factory QualiteDeService.fromJson(Map<String, dynamic> json) {
    return QualiteDeService(
      id: json['id'],
      couleur: json['attributes']['couleur'] ?? '',
      libelle: json['attributes']['libelle'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'couleur': couleur,
      'libelle': libelle,
    };
  }

  dynamic getField(String field) {
    switch (field) {
      case 'couleur':
        return couleur;
      case 'libelle':
        return libelle;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'QualiteDeService{couleur: $couleur, libelle: $libelle}';
  }
}
