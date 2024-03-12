class Service {
  late String id;
  late String libelle;
  late String description;
  late String qualiteDeService;
  late int qualiteDeServiceId;
  late DateTime lastUpdate;

  Service(this.id, this.libelle, this.description, this.qualiteDeService, this.qualiteDeServiceId, this.lastUpdate);

  Service.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    libelle = json['attributes']['libelle'];
    description = json['attributes']['description'];
    qualiteDeService = json['attributes']['qualite_de_service']['data']['attributes']['libelle'];
    qualiteDeServiceId = json['attributes']['qualite_de_service']['data']['id'];
    lastUpdate = DateTime.parse(json['attributes']['updatedAt']);
  }

  //todo à retirer
  Service.fromV3Json(Map<String, dynamic> json) {
    id = json['id'].toString();
    libelle = json['libelle'];
    description = json['description'];
    qualiteDeService = json['qualiteDeService']['libelle'];
    qualiteDeServiceId = json['qualiteDeService']['id'];
    lastUpdate = DateTime.parse(json['updated_at']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id.toString();
    data['libelle'] = libelle;
    data['description'] = description;
    data['qualiteDeService']['libelle'] = qualiteDeService;
    data['qualiteDeService']['id'] = qualiteDeServiceId;
    data['updatedAt'] = lastUpdate;
    return data;
  }
}
