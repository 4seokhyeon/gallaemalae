// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $VisitRecordsTable extends VisitRecords
    with TableInfo<$VisitRecordsTable, VisitRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VisitRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _placeNameMeta = const VerificationMeta(
    'placeName',
  );
  @override
  late final GeneratedColumn<String> placeName = GeneratedColumn<String>(
    'place_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitedAtMeta = const VerificationMeta(
    'visitedAt',
  );
  @override
  late final GeneratedColumn<DateTime> visitedAt = GeneratedColumn<DateTime>(
    'visited_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _crowdLevelMeta = const VerificationMeta(
    'crowdLevel',
  );
  @override
  late final GeneratedColumn<int> crowdLevel = GeneratedColumn<int>(
    'crowd_level',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    placeId,
    placeName,
    visitedAt,
    crowdLevel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'visit_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<VisitRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('place_name')) {
      context.handle(
        _placeNameMeta,
        placeName.isAcceptableOrUnknown(data['place_name']!, _placeNameMeta),
      );
    } else if (isInserting) {
      context.missing(_placeNameMeta);
    }
    if (data.containsKey('visited_at')) {
      context.handle(
        _visitedAtMeta,
        visitedAt.isAcceptableOrUnknown(data['visited_at']!, _visitedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_visitedAtMeta);
    }
    if (data.containsKey('crowd_level')) {
      context.handle(
        _crowdLevelMeta,
        crowdLevel.isAcceptableOrUnknown(data['crowd_level']!, _crowdLevelMeta),
      );
    } else if (isInserting) {
      context.missing(_crowdLevelMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VisitRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VisitRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_id'],
      )!,
      placeName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_name'],
      )!,
      visitedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}visited_at'],
      )!,
      crowdLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}crowd_level'],
      )!,
    );
  }

  @override
  $VisitRecordsTable createAlias(String alias) {
    return $VisitRecordsTable(attachedDatabase, alias);
  }
}

class VisitRecord extends DataClass implements Insertable<VisitRecord> {
  final String id;
  final String placeId;
  final String placeName;
  final DateTime visitedAt;
  final int crowdLevel;
  const VisitRecord({
    required this.id,
    required this.placeId,
    required this.placeName,
    required this.visitedAt,
    required this.crowdLevel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['place_id'] = Variable<String>(placeId);
    map['place_name'] = Variable<String>(placeName);
    map['visited_at'] = Variable<DateTime>(visitedAt);
    map['crowd_level'] = Variable<int>(crowdLevel);
    return map;
  }

  VisitRecordsCompanion toCompanion(bool nullToAbsent) {
    return VisitRecordsCompanion(
      id: Value(id),
      placeId: Value(placeId),
      placeName: Value(placeName),
      visitedAt: Value(visitedAt),
      crowdLevel: Value(crowdLevel),
    );
  }

  factory VisitRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VisitRecord(
      id: serializer.fromJson<String>(json['id']),
      placeId: serializer.fromJson<String>(json['placeId']),
      placeName: serializer.fromJson<String>(json['placeName']),
      visitedAt: serializer.fromJson<DateTime>(json['visitedAt']),
      crowdLevel: serializer.fromJson<int>(json['crowdLevel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'placeId': serializer.toJson<String>(placeId),
      'placeName': serializer.toJson<String>(placeName),
      'visitedAt': serializer.toJson<DateTime>(visitedAt),
      'crowdLevel': serializer.toJson<int>(crowdLevel),
    };
  }

  VisitRecord copyWith({
    String? id,
    String? placeId,
    String? placeName,
    DateTime? visitedAt,
    int? crowdLevel,
  }) => VisitRecord(
    id: id ?? this.id,
    placeId: placeId ?? this.placeId,
    placeName: placeName ?? this.placeName,
    visitedAt: visitedAt ?? this.visitedAt,
    crowdLevel: crowdLevel ?? this.crowdLevel,
  );
  VisitRecord copyWithCompanion(VisitRecordsCompanion data) {
    return VisitRecord(
      id: data.id.present ? data.id.value : this.id,
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      placeName: data.placeName.present ? data.placeName.value : this.placeName,
      visitedAt: data.visitedAt.present ? data.visitedAt.value : this.visitedAt,
      crowdLevel: data.crowdLevel.present
          ? data.crowdLevel.value
          : this.crowdLevel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VisitRecord(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('placeName: $placeName, ')
          ..write('visitedAt: $visitedAt, ')
          ..write('crowdLevel: $crowdLevel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, placeId, placeName, visitedAt, crowdLevel);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VisitRecord &&
          other.id == this.id &&
          other.placeId == this.placeId &&
          other.placeName == this.placeName &&
          other.visitedAt == this.visitedAt &&
          other.crowdLevel == this.crowdLevel);
}

class VisitRecordsCompanion extends UpdateCompanion<VisitRecord> {
  final Value<String> id;
  final Value<String> placeId;
  final Value<String> placeName;
  final Value<DateTime> visitedAt;
  final Value<int> crowdLevel;
  final Value<int> rowid;
  const VisitRecordsCompanion({
    this.id = const Value.absent(),
    this.placeId = const Value.absent(),
    this.placeName = const Value.absent(),
    this.visitedAt = const Value.absent(),
    this.crowdLevel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VisitRecordsCompanion.insert({
    required String id,
    required String placeId,
    required String placeName,
    required DateTime visitedAt,
    required int crowdLevel,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       placeId = Value(placeId),
       placeName = Value(placeName),
       visitedAt = Value(visitedAt),
       crowdLevel = Value(crowdLevel);
  static Insertable<VisitRecord> custom({
    Expression<String>? id,
    Expression<String>? placeId,
    Expression<String>? placeName,
    Expression<DateTime>? visitedAt,
    Expression<int>? crowdLevel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (placeId != null) 'place_id': placeId,
      if (placeName != null) 'place_name': placeName,
      if (visitedAt != null) 'visited_at': visitedAt,
      if (crowdLevel != null) 'crowd_level': crowdLevel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VisitRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? placeId,
    Value<String>? placeName,
    Value<DateTime>? visitedAt,
    Value<int>? crowdLevel,
    Value<int>? rowid,
  }) {
    return VisitRecordsCompanion(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      placeName: placeName ?? this.placeName,
      visitedAt: visitedAt ?? this.visitedAt,
      crowdLevel: crowdLevel ?? this.crowdLevel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (placeName.present) {
      map['place_name'] = Variable<String>(placeName.value);
    }
    if (visitedAt.present) {
      map['visited_at'] = Variable<DateTime>(visitedAt.value);
    }
    if (crowdLevel.present) {
      map['crowd_level'] = Variable<int>(crowdLevel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VisitRecordsCompanion(')
          ..write('id: $id, ')
          ..write('placeId: $placeId, ')
          ..write('placeName: $placeName, ')
          ..write('visitedAt: $visitedAt, ')
          ..write('crowdLevel: $crowdLevel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoritePlacesTable extends FavoritePlaces
    with TableInfo<$FavoritePlacesTable, FavoritePlace> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritePlacesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _placeIdMeta = const VerificationMeta(
    'placeId',
  );
  @override
  late final GeneratedColumn<String> placeId = GeneratedColumn<String>(
    'place_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryCodeMeta = const VerificationMeta(
    'categoryCode',
  );
  @override
  late final GeneratedColumn<String> categoryCode = GeneratedColumn<String>(
    'category_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    placeId,
    name,
    latitude,
    longitude,
    categoryCode,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_places';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoritePlace> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('place_id')) {
      context.handle(
        _placeIdMeta,
        placeId.isAcceptableOrUnknown(data['place_id']!, _placeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_placeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('category_code')) {
      context.handle(
        _categoryCodeMeta,
        categoryCode.isAcceptableOrUnknown(
          data['category_code']!,
          _categoryCodeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {placeId};
  @override
  FavoritePlace map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoritePlace(
      placeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}place_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      categoryCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_code'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FavoritePlacesTable createAlias(String alias) {
    return $FavoritePlacesTable(attachedDatabase, alias);
  }
}

class FavoritePlace extends DataClass implements Insertable<FavoritePlace> {
  final String placeId;
  final String name;
  final double latitude;
  final double longitude;
  final String? categoryCode;
  final DateTime createdAt;
  const FavoritePlace({
    required this.placeId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.categoryCode,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['place_id'] = Variable<String>(placeId);
    map['name'] = Variable<String>(name);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    if (!nullToAbsent || categoryCode != null) {
      map['category_code'] = Variable<String>(categoryCode);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FavoritePlacesCompanion toCompanion(bool nullToAbsent) {
    return FavoritePlacesCompanion(
      placeId: Value(placeId),
      name: Value(name),
      latitude: Value(latitude),
      longitude: Value(longitude),
      categoryCode: categoryCode == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryCode),
      createdAt: Value(createdAt),
    );
  }

  factory FavoritePlace.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoritePlace(
      placeId: serializer.fromJson<String>(json['placeId']),
      name: serializer.fromJson<String>(json['name']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      categoryCode: serializer.fromJson<String?>(json['categoryCode']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'placeId': serializer.toJson<String>(placeId),
      'name': serializer.toJson<String>(name),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'categoryCode': serializer.toJson<String?>(categoryCode),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FavoritePlace copyWith({
    String? placeId,
    String? name,
    double? latitude,
    double? longitude,
    Value<String?> categoryCode = const Value.absent(),
    DateTime? createdAt,
  }) => FavoritePlace(
    placeId: placeId ?? this.placeId,
    name: name ?? this.name,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    categoryCode: categoryCode.present ? categoryCode.value : this.categoryCode,
    createdAt: createdAt ?? this.createdAt,
  );
  FavoritePlace copyWithCompanion(FavoritePlacesCompanion data) {
    return FavoritePlace(
      placeId: data.placeId.present ? data.placeId.value : this.placeId,
      name: data.name.present ? data.name.value : this.name,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      categoryCode: data.categoryCode.present
          ? data.categoryCode.value
          : this.categoryCode,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoritePlace(')
          ..write('placeId: $placeId, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('categoryCode: $categoryCode, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(placeId, name, latitude, longitude, categoryCode, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoritePlace &&
          other.placeId == this.placeId &&
          other.name == this.name &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.categoryCode == this.categoryCode &&
          other.createdAt == this.createdAt);
}

class FavoritePlacesCompanion extends UpdateCompanion<FavoritePlace> {
  final Value<String> placeId;
  final Value<String> name;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String?> categoryCode;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FavoritePlacesCompanion({
    this.placeId = const Value.absent(),
    this.name = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.categoryCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoritePlacesCompanion.insert({
    required String placeId,
    required String name,
    required double latitude,
    required double longitude,
    this.categoryCode = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : placeId = Value(placeId),
       name = Value(name),
       latitude = Value(latitude),
       longitude = Value(longitude);
  static Insertable<FavoritePlace> custom({
    Expression<String>? placeId,
    Expression<String>? name,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? categoryCode,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (placeId != null) 'place_id': placeId,
      if (name != null) 'name': name,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (categoryCode != null) 'category_code': categoryCode,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoritePlacesCompanion copyWith({
    Value<String>? placeId,
    Value<String>? name,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<String?>? categoryCode,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return FavoritePlacesCompanion(
      placeId: placeId ?? this.placeId,
      name: name ?? this.name,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      categoryCode: categoryCode ?? this.categoryCode,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (placeId.present) {
      map['place_id'] = Variable<String>(placeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (categoryCode.present) {
      map['category_code'] = Variable<String>(categoryCode.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritePlacesCompanion(')
          ..write('placeId: $placeId, ')
          ..write('name: $name, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('categoryCode: $categoryCode, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppSetting({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSetting copyWith({String? key, String? value, DateTime? updatedAt}) =>
      AppSetting(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FestivalCacheEntriesTable extends FestivalCacheEntries
    with TableInfo<$FestivalCacheEntriesTable, FestivalCacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FestivalCacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cacheKeyMeta = const VerificationMeta(
    'cacheKey',
  );
  @override
  late final GeneratedColumn<String> cacheKey = GeneratedColumn<String>(
    'cache_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [cacheKey, payload, cachedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'festival_cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FestivalCacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cache_key')) {
      context.handle(
        _cacheKeyMeta,
        cacheKey.isAcceptableOrUnknown(data['cache_key']!, _cacheKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_cacheKeyMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cacheKey};
  @override
  FestivalCacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FestivalCacheEntry(
      cacheKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cache_key'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $FestivalCacheEntriesTable createAlias(String alias) {
    return $FestivalCacheEntriesTable(attachedDatabase, alias);
  }
}

class FestivalCacheEntry extends DataClass
    implements Insertable<FestivalCacheEntry> {
  final String cacheKey;
  final String payload;
  final DateTime cachedAt;
  const FestivalCacheEntry({
    required this.cacheKey,
    required this.payload,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cache_key'] = Variable<String>(cacheKey);
    map['payload'] = Variable<String>(payload);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  FestivalCacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return FestivalCacheEntriesCompanion(
      cacheKey: Value(cacheKey),
      payload: Value(payload),
      cachedAt: Value(cachedAt),
    );
  }

  factory FestivalCacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FestivalCacheEntry(
      cacheKey: serializer.fromJson<String>(json['cacheKey']),
      payload: serializer.fromJson<String>(json['payload']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cacheKey': serializer.toJson<String>(cacheKey),
      'payload': serializer.toJson<String>(payload),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  FestivalCacheEntry copyWith({
    String? cacheKey,
    String? payload,
    DateTime? cachedAt,
  }) => FestivalCacheEntry(
    cacheKey: cacheKey ?? this.cacheKey,
    payload: payload ?? this.payload,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  FestivalCacheEntry copyWithCompanion(FestivalCacheEntriesCompanion data) {
    return FestivalCacheEntry(
      cacheKey: data.cacheKey.present ? data.cacheKey.value : this.cacheKey,
      payload: data.payload.present ? data.payload.value : this.payload,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FestivalCacheEntry(')
          ..write('cacheKey: $cacheKey, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cacheKey, payload, cachedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FestivalCacheEntry &&
          other.cacheKey == this.cacheKey &&
          other.payload == this.payload &&
          other.cachedAt == this.cachedAt);
}

class FestivalCacheEntriesCompanion
    extends UpdateCompanion<FestivalCacheEntry> {
  final Value<String> cacheKey;
  final Value<String> payload;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const FestivalCacheEntriesCompanion({
    this.cacheKey = const Value.absent(),
    this.payload = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FestivalCacheEntriesCompanion.insert({
    required String cacheKey,
    required String payload,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : cacheKey = Value(cacheKey),
       payload = Value(payload),
       cachedAt = Value(cachedAt);
  static Insertable<FestivalCacheEntry> custom({
    Expression<String>? cacheKey,
    Expression<String>? payload,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cacheKey != null) 'cache_key': cacheKey,
      if (payload != null) 'payload': payload,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FestivalCacheEntriesCompanion copyWith({
    Value<String>? cacheKey,
    Value<String>? payload,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return FestivalCacheEntriesCompanion(
      cacheKey: cacheKey ?? this.cacheKey,
      payload: payload ?? this.payload,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cacheKey.present) {
      map['cache_key'] = Variable<String>(cacheKey.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FestivalCacheEntriesCompanion(')
          ..write('cacheKey: $cacheKey, ')
          ..write('payload: $payload, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $VisitRecordsTable visitRecords = $VisitRecordsTable(this);
  late final $FavoritePlacesTable favoritePlaces = $FavoritePlacesTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $FestivalCacheEntriesTable festivalCacheEntries =
      $FestivalCacheEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    visitRecords,
    favoritePlaces,
    appSettings,
    festivalCacheEntries,
  ];
}

typedef $$VisitRecordsTableCreateCompanionBuilder =
    VisitRecordsCompanion Function({
      required String id,
      required String placeId,
      required String placeName,
      required DateTime visitedAt,
      required int crowdLevel,
      Value<int> rowid,
    });
typedef $$VisitRecordsTableUpdateCompanionBuilder =
    VisitRecordsCompanion Function({
      Value<String> id,
      Value<String> placeId,
      Value<String> placeName,
      Value<DateTime> visitedAt,
      Value<int> crowdLevel,
      Value<int> rowid,
    });

class $$VisitRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $VisitRecordsTable> {
  $$VisitRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeId => $composableBuilder(
    column: $table.placeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get visitedAt => $composableBuilder(
    column: $table.visitedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get crowdLevel => $composableBuilder(
    column: $table.crowdLevel,
    builder: (column) => ColumnFilters(column),
  );
}

class $$VisitRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $VisitRecordsTable> {
  $$VisitRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeId => $composableBuilder(
    column: $table.placeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placeName => $composableBuilder(
    column: $table.placeName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get visitedAt => $composableBuilder(
    column: $table.visitedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get crowdLevel => $composableBuilder(
    column: $table.crowdLevel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$VisitRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VisitRecordsTable> {
  $$VisitRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<String> get placeName =>
      $composableBuilder(column: $table.placeName, builder: (column) => column);

  GeneratedColumn<DateTime> get visitedAt =>
      $composableBuilder(column: $table.visitedAt, builder: (column) => column);

  GeneratedColumn<int> get crowdLevel => $composableBuilder(
    column: $table.crowdLevel,
    builder: (column) => column,
  );
}

class $$VisitRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VisitRecordsTable,
          VisitRecord,
          $$VisitRecordsTableFilterComposer,
          $$VisitRecordsTableOrderingComposer,
          $$VisitRecordsTableAnnotationComposer,
          $$VisitRecordsTableCreateCompanionBuilder,
          $$VisitRecordsTableUpdateCompanionBuilder,
          (
            VisitRecord,
            BaseReferences<_$AppDatabase, $VisitRecordsTable, VisitRecord>,
          ),
          VisitRecord,
          PrefetchHooks Function()
        > {
  $$VisitRecordsTableTableManager(_$AppDatabase db, $VisitRecordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VisitRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VisitRecordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VisitRecordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> placeId = const Value.absent(),
                Value<String> placeName = const Value.absent(),
                Value<DateTime> visitedAt = const Value.absent(),
                Value<int> crowdLevel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VisitRecordsCompanion(
                id: id,
                placeId: placeId,
                placeName: placeName,
                visitedAt: visitedAt,
                crowdLevel: crowdLevel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String placeId,
                required String placeName,
                required DateTime visitedAt,
                required int crowdLevel,
                Value<int> rowid = const Value.absent(),
              }) => VisitRecordsCompanion.insert(
                id: id,
                placeId: placeId,
                placeName: placeName,
                visitedAt: visitedAt,
                crowdLevel: crowdLevel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$VisitRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VisitRecordsTable,
      VisitRecord,
      $$VisitRecordsTableFilterComposer,
      $$VisitRecordsTableOrderingComposer,
      $$VisitRecordsTableAnnotationComposer,
      $$VisitRecordsTableCreateCompanionBuilder,
      $$VisitRecordsTableUpdateCompanionBuilder,
      (
        VisitRecord,
        BaseReferences<_$AppDatabase, $VisitRecordsTable, VisitRecord>,
      ),
      VisitRecord,
      PrefetchHooks Function()
    >;
typedef $$FavoritePlacesTableCreateCompanionBuilder =
    FavoritePlacesCompanion Function({
      required String placeId,
      required String name,
      required double latitude,
      required double longitude,
      Value<String?> categoryCode,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });
typedef $$FavoritePlacesTableUpdateCompanionBuilder =
    FavoritePlacesCompanion Function({
      Value<String> placeId,
      Value<String> name,
      Value<double> latitude,
      Value<double> longitude,
      Value<String?> categoryCode,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$FavoritePlacesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritePlacesTable> {
  $$FavoritePlacesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get placeId => $composableBuilder(
    column: $table.placeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoritePlacesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritePlacesTable> {
  $$FavoritePlacesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get placeId => $composableBuilder(
    column: $table.placeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoritePlacesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritePlacesTable> {
  $$FavoritePlacesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get placeId =>
      $composableBuilder(column: $table.placeId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<String> get categoryCode => $composableBuilder(
    column: $table.categoryCode,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$FavoritePlacesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoritePlacesTable,
          FavoritePlace,
          $$FavoritePlacesTableFilterComposer,
          $$FavoritePlacesTableOrderingComposer,
          $$FavoritePlacesTableAnnotationComposer,
          $$FavoritePlacesTableCreateCompanionBuilder,
          $$FavoritePlacesTableUpdateCompanionBuilder,
          (
            FavoritePlace,
            BaseReferences<_$AppDatabase, $FavoritePlacesTable, FavoritePlace>,
          ),
          FavoritePlace,
          PrefetchHooks Function()
        > {
  $$FavoritePlacesTableTableManager(
    _$AppDatabase db,
    $FavoritePlacesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritePlacesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritePlacesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritePlacesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> placeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<String?> categoryCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoritePlacesCompanion(
                placeId: placeId,
                name: name,
                latitude: latitude,
                longitude: longitude,
                categoryCode: categoryCode,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String placeId,
                required String name,
                required double latitude,
                required double longitude,
                Value<String?> categoryCode = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoritePlacesCompanion.insert(
                placeId: placeId,
                name: name,
                latitude: latitude,
                longitude: longitude,
                categoryCode: categoryCode,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoritePlacesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoritePlacesTable,
      FavoritePlace,
      $$FavoritePlacesTableFilterComposer,
      $$FavoritePlacesTableOrderingComposer,
      $$FavoritePlacesTableAnnotationComposer,
      $$FavoritePlacesTableCreateCompanionBuilder,
      $$FavoritePlacesTableUpdateCompanionBuilder,
      (
        FavoritePlace,
        BaseReferences<_$AppDatabase, $FavoritePlacesTable, FavoritePlace>,
      ),
      FavoritePlace,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$FestivalCacheEntriesTableCreateCompanionBuilder =
    FestivalCacheEntriesCompanion Function({
      required String cacheKey,
      required String payload,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$FestivalCacheEntriesTableUpdateCompanionBuilder =
    FestivalCacheEntriesCompanion Function({
      Value<String> cacheKey,
      Value<String> payload,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$FestivalCacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $FestivalCacheEntriesTable> {
  $$FestivalCacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FestivalCacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FestivalCacheEntriesTable> {
  $$FestivalCacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cacheKey => $composableBuilder(
    column: $table.cacheKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FestivalCacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FestivalCacheEntriesTable> {
  $$FestivalCacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cacheKey =>
      $composableBuilder(column: $table.cacheKey, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$FestivalCacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FestivalCacheEntriesTable,
          FestivalCacheEntry,
          $$FestivalCacheEntriesTableFilterComposer,
          $$FestivalCacheEntriesTableOrderingComposer,
          $$FestivalCacheEntriesTableAnnotationComposer,
          $$FestivalCacheEntriesTableCreateCompanionBuilder,
          $$FestivalCacheEntriesTableUpdateCompanionBuilder,
          (
            FestivalCacheEntry,
            BaseReferences<
              _$AppDatabase,
              $FestivalCacheEntriesTable,
              FestivalCacheEntry
            >,
          ),
          FestivalCacheEntry,
          PrefetchHooks Function()
        > {
  $$FestivalCacheEntriesTableTableManager(
    _$AppDatabase db,
    $FestivalCacheEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FestivalCacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FestivalCacheEntriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FestivalCacheEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> cacheKey = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FestivalCacheEntriesCompanion(
                cacheKey: cacheKey,
                payload: payload,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cacheKey,
                required String payload,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => FestivalCacheEntriesCompanion.insert(
                cacheKey: cacheKey,
                payload: payload,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FestivalCacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FestivalCacheEntriesTable,
      FestivalCacheEntry,
      $$FestivalCacheEntriesTableFilterComposer,
      $$FestivalCacheEntriesTableOrderingComposer,
      $$FestivalCacheEntriesTableAnnotationComposer,
      $$FestivalCacheEntriesTableCreateCompanionBuilder,
      $$FestivalCacheEntriesTableUpdateCompanionBuilder,
      (
        FestivalCacheEntry,
        BaseReferences<
          _$AppDatabase,
          $FestivalCacheEntriesTable,
          FestivalCacheEntry
        >,
      ),
      FestivalCacheEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$VisitRecordsTableTableManager get visitRecords =>
      $$VisitRecordsTableTableManager(_db, _db.visitRecords);
  $$FavoritePlacesTableTableManager get favoritePlaces =>
      $$FavoritePlacesTableTableManager(_db, _db.favoritePlaces);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$FestivalCacheEntriesTableTableManager get festivalCacheEntries =>
      $$FestivalCacheEntriesTableTableManager(_db, _db.festivalCacheEntries);
}
