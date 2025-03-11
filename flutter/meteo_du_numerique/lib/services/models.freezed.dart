// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Forecast _$ForecastFromJson(Map<String, dynamic> json) {
  return _Forecast.fromJson(json);
}

/// @nodoc
mixin _$Forecast {
  String get libelle => throw _privateConstructorUsedError;

  String get description => throw _privateConstructorUsedError;

  Categorie get categorie => throw _privateConstructorUsedError;

  ServiceNumerique get serviceNumerique => throw _privateConstructorUsedError;

  QualiteService get qualiteService => throw _privateConstructorUsedError;

  DateTime get dateDebut => throw _privateConstructorUsedError;

  DateTime get dateFin => throw _privateConstructorUsedError;

  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Forecast to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Forecast
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ForecastCopyWith<Forecast> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ForecastCopyWith<$Res> {
  factory $ForecastCopyWith(Forecast value, $Res Function(Forecast) then) = _$ForecastCopyWithImpl<$Res, Forecast>;

  @useResult
  $Res call(
      {String libelle,
      String description,
      Categorie categorie,
      ServiceNumerique serviceNumerique,
      QualiteService qualiteService,
      DateTime dateDebut,
      DateTime dateFin,
      DateTime updatedAt});

  $CategorieCopyWith<$Res> get categorie;

  $ServiceNumeriqueCopyWith<$Res> get serviceNumerique;

  $QualiteServiceCopyWith<$Res> get qualiteService;
}

/// @nodoc
class _$ForecastCopyWithImpl<$Res, $Val extends Forecast> implements $ForecastCopyWith<$Res> {
  _$ForecastCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Forecast
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? libelle = null,
    Object? description = null,
    Object? categorie = null,
    Object? serviceNumerique = null,
    Object? qualiteService = null,
    Object? dateDebut = null,
    Object? dateFin = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      libelle: null == libelle
          ? _value.libelle
          : libelle // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      categorie: null == categorie
          ? _value.categorie
          : categorie // ignore: cast_nullable_to_non_nullable
              as Categorie,
      serviceNumerique: null == serviceNumerique
          ? _value.serviceNumerique
          : serviceNumerique // ignore: cast_nullable_to_non_nullable
              as ServiceNumerique,
      qualiteService: null == qualiteService
          ? _value.qualiteService
          : qualiteService // ignore: cast_nullable_to_non_nullable
              as QualiteService,
      dateDebut: null == dateDebut
          ? _value.dateDebut
          : dateDebut // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateFin: null == dateFin
          ? _value.dateFin
          : dateFin // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of Forecast
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategorieCopyWith<$Res> get categorie {
    return $CategorieCopyWith<$Res>(_value.categorie, (value) {
      return _then(_value.copyWith(categorie: value) as $Val);
    });
  }

  /// Create a copy of Forecast
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ServiceNumeriqueCopyWith<$Res> get serviceNumerique {
    return $ServiceNumeriqueCopyWith<$Res>(_value.serviceNumerique, (value) {
      return _then(_value.copyWith(serviceNumerique: value) as $Val);
    });
  }

  /// Create a copy of Forecast
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QualiteServiceCopyWith<$Res> get qualiteService {
    return $QualiteServiceCopyWith<$Res>(_value.qualiteService, (value) {
      return _then(_value.copyWith(qualiteService: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ForecastImplCopyWith<$Res> implements $ForecastCopyWith<$Res> {
  factory _$$ForecastImplCopyWith(_$ForecastImpl value, $Res Function(_$ForecastImpl) then) = __$$ForecastImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call(
      {String libelle,
      String description,
      Categorie categorie,
      ServiceNumerique serviceNumerique,
      QualiteService qualiteService,
      DateTime dateDebut,
      DateTime dateFin,
      DateTime updatedAt});

  @override
  $CategorieCopyWith<$Res> get categorie;

  @override
  $ServiceNumeriqueCopyWith<$Res> get serviceNumerique;

  @override
  $QualiteServiceCopyWith<$Res> get qualiteService;
}

/// @nodoc
class __$$ForecastImplCopyWithImpl<$Res> extends _$ForecastCopyWithImpl<$Res, _$ForecastImpl> implements _$$ForecastImplCopyWith<$Res> {
  __$$ForecastImplCopyWithImpl(_$ForecastImpl _value, $Res Function(_$ForecastImpl) _then) : super(_value, _then);

  /// Create a copy of Forecast
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? libelle = null,
    Object? description = null,
    Object? categorie = null,
    Object? serviceNumerique = null,
    Object? qualiteService = null,
    Object? dateDebut = null,
    Object? dateFin = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ForecastImpl(
      libelle: null == libelle
          ? _value.libelle
          : libelle // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      categorie: null == categorie
          ? _value.categorie
          : categorie // ignore: cast_nullable_to_non_nullable
              as Categorie,
      serviceNumerique: null == serviceNumerique
          ? _value.serviceNumerique
          : serviceNumerique // ignore: cast_nullable_to_non_nullable
              as ServiceNumerique,
      qualiteService: null == qualiteService
          ? _value.qualiteService
          : qualiteService // ignore: cast_nullable_to_non_nullable
              as QualiteService,
      dateDebut: null == dateDebut
          ? _value.dateDebut
          : dateDebut // ignore: cast_nullable_to_non_nullable
              as DateTime,
      dateFin: null == dateFin
          ? _value.dateFin
          : dateFin // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$ForecastImpl implements _Forecast {
  const _$ForecastImpl(
      {required this.libelle,
      required this.description,
      required this.categorie,
      required this.serviceNumerique,
      required this.qualiteService,
      required this.dateDebut,
      required this.dateFin,
      required this.updatedAt});

  factory _$ForecastImpl.fromJson(Map<String, dynamic> json) => _$$ForecastImplFromJson(json);

  @override
  final String libelle;
  @override
  final String description;
  @override
  final Categorie categorie;
  @override
  final ServiceNumerique serviceNumerique;
  @override
  final QualiteService qualiteService;
  @override
  final DateTime dateDebut;
  @override
  final DateTime dateFin;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'Forecast(libelle: $libelle, description: $description, categorie: $categorie, serviceNumerique: $serviceNumerique, qualiteService: $qualiteService, dateDebut: $dateDebut, dateFin: $dateFin, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ForecastImpl &&
            (identical(other.libelle, libelle) || other.libelle == libelle) &&
            (identical(other.description, description) || other.description == description) &&
            (identical(other.categorie, categorie) || other.categorie == categorie) &&
            (identical(other.serviceNumerique, serviceNumerique) || other.serviceNumerique == serviceNumerique) &&
            (identical(other.qualiteService, qualiteService) || other.qualiteService == qualiteService) &&
            (identical(other.dateDebut, dateDebut) || other.dateDebut == dateDebut) &&
            (identical(other.dateFin, dateFin) || other.dateFin == dateFin) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, libelle, description, categorie, serviceNumerique, qualiteService, dateDebut, dateFin, updatedAt);

  /// Create a copy of Forecast
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ForecastImplCopyWith<_$ForecastImpl> get copyWith => __$$ForecastImplCopyWithImpl<_$ForecastImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ForecastImplToJson(
      this,
    );
  }
}

abstract class _Forecast implements Forecast {
  const factory _Forecast(
      {required final String libelle,
      required final String description,
      required final Categorie categorie,
      required final ServiceNumerique serviceNumerique,
      required final QualiteService qualiteService,
      required final DateTime dateDebut,
      required final DateTime dateFin,
      required final DateTime updatedAt}) = _$ForecastImpl;

  factory _Forecast.fromJson(Map<String, dynamic> json) = _$ForecastImpl.fromJson;

  @override
  String get libelle;

  @override
  String get description;

  @override
  Categorie get categorie;

  @override
  ServiceNumerique get serviceNumerique;

  @override
  QualiteService get qualiteService;

  @override
  DateTime get dateDebut;

  @override
  DateTime get dateFin;

  @override
  DateTime get updatedAt;

  /// Create a copy of Forecast
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ForecastImplCopyWith<_$ForecastImpl> get copyWith => throw _privateConstructorUsedError;
}

News _$NewsFromJson(Map<String, dynamic> json) {
  return _News.fromJson(json);
}

/// @nodoc
mixin _$News {
  String get libelle => throw _privateConstructorUsedError;

  String get description => throw _privateConstructorUsedError;

  Categorie get categorie => throw _privateConstructorUsedError;

  ServiceNumerique get serviceNumerique => throw _privateConstructorUsedError;

  QualiteService get qualiteService => throw _privateConstructorUsedError;

  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this News to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of News
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewsCopyWith<News> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewsCopyWith<$Res> {
  factory $NewsCopyWith(News value, $Res Function(News) then) = _$NewsCopyWithImpl<$Res, News>;

  @useResult
  $Res call(
      {String libelle,
      String description,
      Categorie categorie,
      ServiceNumerique serviceNumerique,
      QualiteService qualiteService,
      DateTime updatedAt});

  $CategorieCopyWith<$Res> get categorie;

  $ServiceNumeriqueCopyWith<$Res> get serviceNumerique;

  $QualiteServiceCopyWith<$Res> get qualiteService;
}

/// @nodoc
class _$NewsCopyWithImpl<$Res, $Val extends News> implements $NewsCopyWith<$Res> {
  _$NewsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of News
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? libelle = null,
    Object? description = null,
    Object? categorie = null,
    Object? serviceNumerique = null,
    Object? qualiteService = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      libelle: null == libelle
          ? _value.libelle
          : libelle // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      categorie: null == categorie
          ? _value.categorie
          : categorie // ignore: cast_nullable_to_non_nullable
              as Categorie,
      serviceNumerique: null == serviceNumerique
          ? _value.serviceNumerique
          : serviceNumerique // ignore: cast_nullable_to_non_nullable
              as ServiceNumerique,
      qualiteService: null == qualiteService
          ? _value.qualiteService
          : qualiteService // ignore: cast_nullable_to_non_nullable
              as QualiteService,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  /// Create a copy of News
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CategorieCopyWith<$Res> get categorie {
    return $CategorieCopyWith<$Res>(_value.categorie, (value) {
      return _then(_value.copyWith(categorie: value) as $Val);
    });
  }

  /// Create a copy of News
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ServiceNumeriqueCopyWith<$Res> get serviceNumerique {
    return $ServiceNumeriqueCopyWith<$Res>(_value.serviceNumerique, (value) {
      return _then(_value.copyWith(serviceNumerique: value) as $Val);
    });
  }

  /// Create a copy of News
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QualiteServiceCopyWith<$Res> get qualiteService {
    return $QualiteServiceCopyWith<$Res>(_value.qualiteService, (value) {
      return _then(_value.copyWith(qualiteService: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$NewsImplCopyWith<$Res> implements $NewsCopyWith<$Res> {
  factory _$$NewsImplCopyWith(_$NewsImpl value, $Res Function(_$NewsImpl) then) = __$$NewsImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call(
      {String libelle,
      String description,
      Categorie categorie,
      ServiceNumerique serviceNumerique,
      QualiteService qualiteService,
      DateTime updatedAt});

  @override
  $CategorieCopyWith<$Res> get categorie;

  @override
  $ServiceNumeriqueCopyWith<$Res> get serviceNumerique;

  @override
  $QualiteServiceCopyWith<$Res> get qualiteService;
}

/// @nodoc
class __$$NewsImplCopyWithImpl<$Res> extends _$NewsCopyWithImpl<$Res, _$NewsImpl> implements _$$NewsImplCopyWith<$Res> {
  __$$NewsImplCopyWithImpl(_$NewsImpl _value, $Res Function(_$NewsImpl) _then) : super(_value, _then);

  /// Create a copy of News
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? libelle = null,
    Object? description = null,
    Object? categorie = null,
    Object? serviceNumerique = null,
    Object? qualiteService = null,
    Object? updatedAt = null,
  }) {
    return _then(_$NewsImpl(
      libelle: null == libelle
          ? _value.libelle
          : libelle // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      categorie: null == categorie
          ? _value.categorie
          : categorie // ignore: cast_nullable_to_non_nullable
              as Categorie,
      serviceNumerique: null == serviceNumerique
          ? _value.serviceNumerique
          : serviceNumerique // ignore: cast_nullable_to_non_nullable
              as ServiceNumerique,
      qualiteService: null == qualiteService
          ? _value.qualiteService
          : qualiteService // ignore: cast_nullable_to_non_nullable
              as QualiteService,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$NewsImpl implements _News {
  const _$NewsImpl(
      {required this.libelle,
      required this.description,
      required this.categorie,
      required this.serviceNumerique,
      required this.qualiteService,
      required this.updatedAt});

  factory _$NewsImpl.fromJson(Map<String, dynamic> json) => _$$NewsImplFromJson(json);

  @override
  final String libelle;
  @override
  final String description;
  @override
  final Categorie categorie;
  @override
  final ServiceNumerique serviceNumerique;
  @override
  final QualiteService qualiteService;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'News(libelle: $libelle, description: $description, categorie: $categorie, serviceNumerique: $serviceNumerique, qualiteService: $qualiteService, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewsImpl &&
            (identical(other.libelle, libelle) || other.libelle == libelle) &&
            (identical(other.description, description) || other.description == description) &&
            (identical(other.categorie, categorie) || other.categorie == categorie) &&
            (identical(other.serviceNumerique, serviceNumerique) || other.serviceNumerique == serviceNumerique) &&
            (identical(other.qualiteService, qualiteService) || other.qualiteService == qualiteService) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, libelle, description, categorie, serviceNumerique, qualiteService, updatedAt);

  /// Create a copy of News
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewsImplCopyWith<_$NewsImpl> get copyWith => __$$NewsImplCopyWithImpl<_$NewsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NewsImplToJson(
      this,
    );
  }
}

abstract class _News implements News {
  const factory _News(
      {required final String libelle,
      required final String description,
      required final Categorie categorie,
      required final ServiceNumerique serviceNumerique,
      required final QualiteService qualiteService,
      required final DateTime updatedAt}) = _$NewsImpl;

  factory _News.fromJson(Map<String, dynamic> json) = _$NewsImpl.fromJson;

  @override
  String get libelle;

  @override
  String get description;

  @override
  Categorie get categorie;

  @override
  ServiceNumerique get serviceNumerique;

  @override
  QualiteService get qualiteService;

  @override
  DateTime get updatedAt;

  /// Create a copy of News
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewsImplCopyWith<_$NewsImpl> get copyWith => throw _privateConstructorUsedError;
}

Categorie _$CategorieFromJson(Map<String, dynamic> json) {
  return _Categorie.fromJson(json);
}

/// @nodoc
mixin _$Categorie {
  String get key => throw _privateConstructorUsedError;

  String get libelle => throw _privateConstructorUsedError;

  String get couleur => throw _privateConstructorUsedError;

  /// Serializes this Categorie to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Categorie
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategorieCopyWith<Categorie> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategorieCopyWith<$Res> {
  factory $CategorieCopyWith(Categorie value, $Res Function(Categorie) then) = _$CategorieCopyWithImpl<$Res, Categorie>;

  @useResult
  $Res call({String key, String libelle, String couleur});
}

/// @nodoc
class _$CategorieCopyWithImpl<$Res, $Val extends Categorie> implements $CategorieCopyWith<$Res> {
  _$CategorieCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Categorie
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? libelle = null,
    Object? couleur = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      libelle: null == libelle
          ? _value.libelle
          : libelle // ignore: cast_nullable_to_non_nullable
              as String,
      couleur: null == couleur
          ? _value.couleur
          : couleur // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategorieImplCopyWith<$Res> implements $CategorieCopyWith<$Res> {
  factory _$$CategorieImplCopyWith(_$CategorieImpl value, $Res Function(_$CategorieImpl) then) = __$$CategorieImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call({String key, String libelle, String couleur});
}

/// @nodoc
class __$$CategorieImplCopyWithImpl<$Res> extends _$CategorieCopyWithImpl<$Res, _$CategorieImpl> implements _$$CategorieImplCopyWith<$Res> {
  __$$CategorieImplCopyWithImpl(_$CategorieImpl _value, $Res Function(_$CategorieImpl) _then) : super(_value, _then);

  /// Create a copy of Categorie
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? libelle = null,
    Object? couleur = null,
  }) {
    return _then(_$CategorieImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      libelle: null == libelle
          ? _value.libelle
          : libelle // ignore: cast_nullable_to_non_nullable
              as String,
      couleur: null == couleur
          ? _value.couleur
          : couleur // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategorieImpl implements _Categorie {
  const _$CategorieImpl({required this.key, required this.libelle, required this.couleur});

  factory _$CategorieImpl.fromJson(Map<String, dynamic> json) => _$$CategorieImplFromJson(json);

  @override
  final String key;
  @override
  final String libelle;
  @override
  final String couleur;

  @override
  String toString() {
    return 'Categorie(key: $key, libelle: $libelle, couleur: $couleur)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategorieImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.libelle, libelle) || other.libelle == libelle) &&
            (identical(other.couleur, couleur) || other.couleur == couleur));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, libelle, couleur);

  /// Create a copy of Categorie
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategorieImplCopyWith<_$CategorieImpl> get copyWith => __$$CategorieImplCopyWithImpl<_$CategorieImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategorieImplToJson(
      this,
    );
  }
}

abstract class _Categorie implements Categorie {
  const factory _Categorie({required final String key, required final String libelle, required final String couleur}) = _$CategorieImpl;

  factory _Categorie.fromJson(Map<String, dynamic> json) = _$CategorieImpl.fromJson;

  @override
  String get key;

  @override
  String get libelle;

  @override
  String get couleur;

  /// Create a copy of Categorie
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategorieImplCopyWith<_$CategorieImpl> get copyWith => throw _privateConstructorUsedError;
}

ServiceNumerique _$ServiceNumeriqueFromJson(Map<String, dynamic> json) {
  return _ServiceNumerique.fromJson(json);
}

/// @nodoc
mixin _$ServiceNumerique {
  String get libelle => throw _privateConstructorUsedError;

  String get description => throw _privateConstructorUsedError;

  String get vignette => throw _privateConstructorUsedError;

  /// Serializes this ServiceNumerique to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceNumerique
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceNumeriqueCopyWith<ServiceNumerique> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceNumeriqueCopyWith<$Res> {
  factory $ServiceNumeriqueCopyWith(ServiceNumerique value, $Res Function(ServiceNumerique) then) =
      _$ServiceNumeriqueCopyWithImpl<$Res, ServiceNumerique>;

  @useResult
  $Res call({String libelle, String description, String vignette});
}

/// @nodoc
class _$ServiceNumeriqueCopyWithImpl<$Res, $Val extends ServiceNumerique> implements $ServiceNumeriqueCopyWith<$Res> {
  _$ServiceNumeriqueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceNumerique
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? libelle = null,
    Object? description = null,
    Object? vignette = null,
  }) {
    return _then(_value.copyWith(
      libelle: null == libelle
          ? _value.libelle
          : libelle // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      vignette: null == vignette
          ? _value.vignette
          : vignette // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ServiceNumeriqueImplCopyWith<$Res> implements $ServiceNumeriqueCopyWith<$Res> {
  factory _$$ServiceNumeriqueImplCopyWith(_$ServiceNumeriqueImpl value, $Res Function(_$ServiceNumeriqueImpl) then) =
      __$$ServiceNumeriqueImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call({String libelle, String description, String vignette});
}

/// @nodoc
class __$$ServiceNumeriqueImplCopyWithImpl<$Res> extends _$ServiceNumeriqueCopyWithImpl<$Res, _$ServiceNumeriqueImpl>
    implements _$$ServiceNumeriqueImplCopyWith<$Res> {
  __$$ServiceNumeriqueImplCopyWithImpl(_$ServiceNumeriqueImpl _value, $Res Function(_$ServiceNumeriqueImpl) _then) : super(_value, _then);

  /// Create a copy of ServiceNumerique
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? libelle = null,
    Object? description = null,
    Object? vignette = null,
  }) {
    return _then(_$ServiceNumeriqueImpl(
      libelle: null == libelle
          ? _value.libelle
          : libelle // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      vignette: null == vignette
          ? _value.vignette
          : vignette // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ServiceNumeriqueImpl implements _ServiceNumerique {
  const _$ServiceNumeriqueImpl({required this.libelle, required this.description, required this.vignette});

  factory _$ServiceNumeriqueImpl.fromJson(Map<String, dynamic> json) => _$$ServiceNumeriqueImplFromJson(json);

  @override
  final String libelle;
  @override
  final String description;
  @override
  final String vignette;

  @override
  String toString() {
    return 'ServiceNumerique(libelle: $libelle, description: $description, vignette: $vignette)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceNumeriqueImpl &&
            (identical(other.libelle, libelle) || other.libelle == libelle) &&
            (identical(other.description, description) || other.description == description) &&
            (identical(other.vignette, vignette) || other.vignette == vignette));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, libelle, description, vignette);

  /// Create a copy of ServiceNumerique
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceNumeriqueImplCopyWith<_$ServiceNumeriqueImpl> get copyWith =>
      __$$ServiceNumeriqueImplCopyWithImpl<_$ServiceNumeriqueImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceNumeriqueImplToJson(
      this,
    );
  }
}

abstract class _ServiceNumerique implements ServiceNumerique {
  const factory _ServiceNumerique({required final String libelle, required final String description, required final String vignette}) =
      _$ServiceNumeriqueImpl;

  factory _ServiceNumerique.fromJson(Map<String, dynamic> json) = _$ServiceNumeriqueImpl.fromJson;

  @override
  String get libelle;

  @override
  String get description;

  @override
  String get vignette;

  /// Create a copy of ServiceNumerique
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceNumeriqueImplCopyWith<_$ServiceNumeriqueImpl> get copyWith => throw _privateConstructorUsedError;
}

QualiteService _$QualiteServiceFromJson(Map<String, dynamic> json) {
  return _QualiteService.fromJson(json);
}

/// @nodoc
mixin _$QualiteService {
  String get key => throw _privateConstructorUsedError;

  String get libelle => throw _privateConstructorUsedError;

  /// Serializes this QualiteService to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QualiteService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QualiteServiceCopyWith<QualiteService> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QualiteServiceCopyWith<$Res> {
  factory $QualiteServiceCopyWith(QualiteService value, $Res Function(QualiteService) then) = _$QualiteServiceCopyWithImpl<$Res, QualiteService>;

  @useResult
  $Res call({String key, String libelle});
}

/// @nodoc
class _$QualiteServiceCopyWithImpl<$Res, $Val extends QualiteService> implements $QualiteServiceCopyWith<$Res> {
  _$QualiteServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QualiteService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? libelle = null,
  }) {
    return _then(_value.copyWith(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      libelle: null == libelle
          ? _value.libelle
          : libelle // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QualiteServiceImplCopyWith<$Res> implements $QualiteServiceCopyWith<$Res> {
  factory _$$QualiteServiceImplCopyWith(_$QualiteServiceImpl value, $Res Function(_$QualiteServiceImpl) then) =
      __$$QualiteServiceImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call({String key, String libelle});
}

/// @nodoc
class __$$QualiteServiceImplCopyWithImpl<$Res> extends _$QualiteServiceCopyWithImpl<$Res, _$QualiteServiceImpl>
    implements _$$QualiteServiceImplCopyWith<$Res> {
  __$$QualiteServiceImplCopyWithImpl(_$QualiteServiceImpl _value, $Res Function(_$QualiteServiceImpl) _then) : super(_value, _then);

  /// Create a copy of QualiteService
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? key = null,
    Object? libelle = null,
  }) {
    return _then(_$QualiteServiceImpl(
      key: null == key
          ? _value.key
          : key // ignore: cast_nullable_to_non_nullable
              as String,
      libelle: null == libelle
          ? _value.libelle
          : libelle // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QualiteServiceImpl implements _QualiteService {
  const _$QualiteServiceImpl({required this.key, required this.libelle});

  factory _$QualiteServiceImpl.fromJson(Map<String, dynamic> json) => _$$QualiteServiceImplFromJson(json);

  @override
  final String key;
  @override
  final String libelle;

  @override
  String toString() {
    return 'QualiteService(key: $key, libelle: $libelle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QualiteServiceImpl &&
            (identical(other.key, key) || other.key == key) &&
            (identical(other.libelle, libelle) || other.libelle == libelle));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, key, libelle);

  /// Create a copy of QualiteService
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QualiteServiceImplCopyWith<_$QualiteServiceImpl> get copyWith => __$$QualiteServiceImplCopyWithImpl<_$QualiteServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QualiteServiceImplToJson(
      this,
    );
  }
}

abstract class _QualiteService implements QualiteService {
  const factory _QualiteService({required final String key, required final String libelle}) = _$QualiteServiceImpl;

  factory _QualiteService.fromJson(Map<String, dynamic> json) = _$QualiteServiceImpl.fromJson;

  @override
  String get key;

  @override
  String get libelle;

  /// Create a copy of QualiteService
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QualiteServiceImplCopyWith<_$QualiteServiceImpl> get copyWith => throw _privateConstructorUsedError;
}
