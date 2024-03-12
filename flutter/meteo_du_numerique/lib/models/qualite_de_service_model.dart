class QualiteDeService {
  late int id;
  late String couleur;
  late String libelle;
  late int niveauQos;

  QualiteDeService({
    required this.id,
    required this.couleur,
    required this.libelle,
    required this.niveauQos,
  });

  factory QualiteDeService.fromJson(Map<String, dynamic> json) {
    return QualiteDeService(
      id: json['id'],
      couleur: json['attributes']['couleur'] ?? '',
      libelle: json['attributes']['libelle'] ?? '',
      niveauQos: json['attributes']['niveau_qos'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'couleur': couleur,
      'libelle': libelle,
      'niveau_qos': niveauQos,
    };
  }

  dynamic getField(String field) {
    switch (field) {
      case 'couleur':
        return couleur;
      case 'libelle':
        return libelle;
      case 'niveau_qos':
        return niveauQos;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'QualiteDeService{couleur: $couleur, libelle: $libelle}';
  }
}
