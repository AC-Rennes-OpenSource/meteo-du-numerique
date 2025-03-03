class ServiceQuality {
  late int id;
  late String label;
  late int qualityLevel;

  ServiceQuality({
    required this.id,
    required this.label,
    required this.qualityLevel,
  });

  factory ServiceQuality.fromJson(Map<String, dynamic> json) {
    return ServiceQuality(
      id: json['id'] as int,
      label: json['libelle'] as String? ?? '',
      qualityLevel: json['key'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'quality_level': qualityLevel,
    };
  }

  dynamic getField(String field) {
    switch (field) {
      case 'label':
        return label;
      case 'quality_level':
        return qualityLevel;
      default:
        return null;
    }
  }

  @override
  String toString() {
    return 'ServiceQuality{label: $label, qualityLevel: $qualityLevel}';
  }
}