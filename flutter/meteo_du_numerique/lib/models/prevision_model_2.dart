class PrevisionsResponse {
  final List<PrevisionData> data;
  final Meta meta;

  PrevisionsResponse({required this.data, required this.meta});

  factory PrevisionsResponse.fromJson(Map<String, dynamic> json) {
    return PrevisionsResponse(
      data: (json['data'] as List)
          .map((item) => PrevisionData.fromJson(item))
          .toList(),
      meta: Meta.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
      'meta': meta.toJson(),
    };
  }
}

class PrevisionData {
  final int id;
  final PrevisionAttributes attributes;

  PrevisionData({required this.id, required this.attributes});

  factory PrevisionData.fromJson(Map<String, dynamic> json) {
    return PrevisionData(
      id: json['id'],
      attributes: PrevisionAttributes.fromJson(json['attributes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': attributes.toJson(),
    };
  }
}

class PrevisionAttributes {
  final String libelle;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishedAt;

  PrevisionAttributes({
    required this.libelle,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
  });

  factory PrevisionAttributes.fromJson(Map<String, dynamic> json) {
    return PrevisionAttributes(
      libelle: json['libelle'],
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      publishedAt: DateTime.parse(json['publishedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'libelle': libelle,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'publishedAt': publishedAt.toIso8601String(),
    };
  }
}

class Meta {
  final Pagination pagination;

  Meta({required this.pagination});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagination': pagination.toJson(),
    };
  }
}

class Pagination {
  final int page;
  final int pageSize;
  final int pageCount;
  final int total;

  Pagination({
    required this.page,
    required this.pageSize,
    required this.pageCount,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'],
      pageSize: json['pageSize'],
      pageCount: json['pageCount'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'pageCount': pageCount,
      'total': total,
    };
  }
}