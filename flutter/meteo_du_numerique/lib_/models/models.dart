
class ServiceNumerique {
  final int id;
  final String libelle;
  final String description;
  final DateTime lastUpdate;
  final Category? category;
  final QualiteDeService? qualiteDeService;
  final List<Prevision>? previsions;

  ServiceNumerique({
    required this.id,
    required this.libelle,
    required this.description,
    required this.lastUpdate,
    this.category,
    this.qualiteDeService,
    this.previsions,
  });

  factory ServiceNumerique.fromJson(Map<String, dynamic> json) {
    return ServiceNumerique(
      id: json['id'],
      libelle: json['attributes']['libelle'],
      description: json['attributes']['description'],
      lastUpdate: DateTime.parse(json['attributes']['lastUpdate']),
      category: Category.fromJson(json['attributes']['category']['data']),
      qualiteDeService: json['attributes']['qualiteDeService']['data'] != null
          ? QualiteDeService.fromJson(json['attributes']['qualiteDeService']['data'])
          : null,
      previsions: json['attributes']['previsions']['data'] != null
          ? (json['attributes']['previsions']['data'] as List)
          .map((i) => Prevision.fromJson(i))
          .toList()
          : null,
    );
  }

  String get qualiteDeServiceNom => qualiteDeService?.libelle ?? 'Non défini';
  String get qualiteDeServiceCouleur => qualiteDeService?.color ?? '#FFFFFF';
}

class QualiteDeService {
  final int id;
  final String libelle;
  final String color;

  QualiteDeService({
    required this.id,
    required this.libelle,
    required this.color,
  });

  factory QualiteDeService.fromJson(Map<String, dynamic> json) {
    return QualiteDeService(
      id: json['id'],
      libelle: json['attributes']['libelle'],
      color: json['attributes']['color'],
    );
  }
}

class Prevision {
  final int id;
  final String libelle;
  final String description;
  final DateTime dateDebut;
  final DateTime lastUpdate;
  final Category? category;

  Prevision({
    required this.id,
    required this.libelle,
    required this.description,
    required this.dateDebut,
    required this.lastUpdate,
    this.category,
  });

  factory Prevision.fromJson(Map<String, dynamic> json) {
    return Prevision(
      id: json['id'],
      libelle: json['attributes']['libelle'],
      description: json['attributes']['description'],
      dateDebut: DateTime.parse(json['attributes']['dateDebut']),
      lastUpdate: DateTime.parse(json['attributes']['lastUpdate']),
      category: json['attributes']['category']['data'] != null
          ? Category.fromJson(json['attributes']['category']['data'])
          : null,
    );
  }

  String get categoryNom => category?.libelle ?? 'Non défini';
  String get categoryCouleur => category?.color ?? '#FFFFFF';
}

class PrevisionGroup {
  final String dateDebut;
  final List<Prevision> previsions;
  bool isExpanded;

  PrevisionGroup({
    required this.dateDebut,
    required this.previsions,
    this.isExpanded = true,
  });

  PrevisionGroup copyWith({String? dateDebut, List<Prevision>? previsions, bool? isExpanded}) {
    return PrevisionGroup(
      dateDebut: dateDebut ?? this.dateDebut,
      previsions: previsions ?? this.previsions,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

class Category {
  final int id;
  final String libelle;
  final String color;

  Category({
    required this.id,
    required this.libelle,
    required this.color,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      libelle: json['attributes']['libelle'],
      color: json['attributes']['color'],
    );
  }
}

class DataManager {
  List<ServiceNumerique> services = [];
  List<Prevision> previsions = [];

  void updateData(List<ServiceNumerique> newServices, List<Prevision> newPrevisions) {
    services = newServices;
    previsions = newPrevisions;
  }

  DateTime get lastUpdateGeneral {
    List<DateTime> allDates = [
      ...services.map((s) => s.lastUpdate),
      ...previsions.map((p) => p.lastUpdate),
    ];
    return allDates.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  List<Prevision> filteredPrevisions({required Category category, required DateTime startDate}) {
    return previsions.where((p) =>
    p.category?.id == category.id && p.dateDebut.isAfter(startDate)
    ).toList();
  }

  List<ServiceNumerique> filteredServices({required QualiteDeService qos}) {
    return services.where((s) => s.qualiteDeService?.id == qos.id).toList();
  }

  List<ServiceNumerique> sortedServices({required bool byState, required bool byName}) {
    List<ServiceNumerique> sortedList = List.from(services);
    sortedList.sort((a, b) {
      if (byState) {
        int stateComp = (a.qualiteDeService?.id ?? 0).compareTo(b.qualiteDeService?.id ?? 0);
        if (stateComp != 0) return stateComp;
      }
      if (byName) {
        return a.libelle.compareTo(b.libelle);
      }
      return 0;
    });
    return sortedList;
  }

}
