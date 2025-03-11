class QualiteDeService {
  late int id;
  late String libelle;
  late int niveauQos;

  QualiteDeService({
    required this.id,
    required this.libelle,
    required this.niveauQos,
  });

  factory QualiteDeService.fromJson(Map<String, dynamic> json) {
    return QualiteDeService(
      id: json['id'] as int,
      libelle: json['libelle'] as String? ?? '',
      niveauQos: json['key'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'libelle': libelle,
      'niveau_qos': niveauQos,
    };
  }

  dynamic getField(String field) {
    switch (field) {
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
    return 'QualiteDeService{libelle: $libelle}';
  }
}