class ServiceNumOld {
  late String id;
  late String libelle;
  late String description;
  late String qualiteDeService;
  late int qualiteDeServiceId;
  late DateTime lastUpdate;
  late String category;

  ServiceNumOld({required this.id,
    required this.libelle,
    required this.description,
    required this.qualiteDeService,
    required this.category,
    required this.qualiteDeServiceId,
    required this.lastUpdate});

  factory ServiceNumOld.fromJson(Map<String, dynamic> json) {
    return ServiceNumOld(
      id: json['id']?.toString() ?? '',
      libelle: json['libelle'] ?? '',
      description: json['description'] ?? '',
      qualiteDeService: json['qualiteDeService']['libelle'] ?? '',
      qualiteDeServiceId: json['qualiteDeService']['id'] ?? 0,
      lastUpdate: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : DateTime.now(),
      category: json['category'] ?? '',
    );
  }


  dynamic getField(String field) {
    switch (field) {
      case 'libelle':
        return libelle;
      case 'category':
        return category;
      case 'qualiteDeService':
        return qualiteDeService;
      case 'description':
        return description;
      case 'lastUpdate':
        return lastUpdate;
      case 'qualiteDeServiceId':
        return qualiteDeServiceId;
      default:
        return null;
    }
  }
}





