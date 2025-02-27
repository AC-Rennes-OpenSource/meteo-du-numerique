class Prevision {
  late String id;
  late String libelle;
  late String description;
  late String qualiteDeService;
  late int qualiteDeServiceId;
  late DateTime lastUpdate;
  late DateTime dateDebut;
  late String category;
  late String color;

  Prevision(
      {required this.id,
      required this.libelle,
      required this.description,
      required this.dateDebut,
      required this.category,
      required this.color,
      required this.lastUpdate});

  factory Prevision.fromJson(Map<String, dynamic> json) {
    return Prevision(
      id: json['attributes']['previsions']['data'][0]['id']?.toString() ?? '',
      libelle: json['attributes']['previsions']['data'][0]['attributes']['libelle'] ?? '',
      description: json['attributes']['previsions']['data'][0]['attributes']['description'] ?? '',
      dateDebut: json['attributes']['previsions']['data'][0]['attributes']['date_debut'] != null
          ? DateTime.parse(json['attributes']['previsions']['data'][0]['attributes']['date_debut'])
          : DateTime.now(),
      category: json['attributes']['categorie']['data']['attributes']['libelle'] ?? '',
      color: json['attributes']['categorie']['data']['attributes']['couleur'] ?? '',
      lastUpdate: json['attributes']['previsions']['data'][0]['attributes']['updatedAt'] != null
          ? DateTime.parse(json['attributes']['previsions']['data'][0]['attributes']['updatedAt'])
          : DateTime.now(),
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
      case 'dateDebut':
        return dateDebut;
      case 'qualiteDeServiceId':
        return qualiteDeServiceId;
      case 'lastUpdate':
        return lastUpdate;
      case 'color':
        return color;
      default:
        return null;
    }
  }
}
