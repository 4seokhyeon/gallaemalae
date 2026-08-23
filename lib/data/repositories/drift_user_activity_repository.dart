import 'package:drift/drift.dart';
import 'package:gallaemalae/data/local/app_database.dart';
import 'package:gallaemalae/domain/entities/favorite_place.dart' as domain;
import 'package:gallaemalae/domain/entities/visit.dart' as domain;
import 'package:gallaemalae/domain/repositories/user_activity_repository.dart';

class DriftUserActivityRepository implements UserActivityRepository {
  DriftUserActivityRepository(this._database);

  final AppDatabase _database;

  @override
  Stream<List<domain.Visit>> watchVisits() {
    final query = _database.select(_database.visitRecords)
      ..orderBy([(row) => OrderingTerm.desc(row.visitedAt)]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => domain.Visit(
              id: row.id,
              placeId: row.placeId,
              placeName: row.placeName,
              visitedAt: row.visitedAt,
              crowdLevel: row.crowdLevel,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> saveVisit(domain.Visit visit) {
    return _database
        .into(_database.visitRecords)
        .insertOnConflictUpdate(
          VisitRecordsCompanion.insert(
            id: visit.id,
            placeId: visit.placeId,
            placeName: visit.placeName,
            visitedAt: visit.visitedAt,
            crowdLevel: visit.crowdLevel,
          ),
        );
  }

  @override
  Future<void> deleteVisit(String id) {
    return (_database.delete(
      _database.visitRecords,
    )..where((row) => row.id.equals(id))).go();
  }

  @override
  Stream<List<domain.FavoritePlace>> watchFavorites() {
    final query = _database.select(_database.favoritePlaces)
      ..orderBy([(row) => OrderingTerm.desc(row.createdAt)]);
    return query.watch().map(
      (rows) => rows
          .map(
            (row) => domain.FavoritePlace(
              placeId: row.placeId,
              name: row.name,
              latitude: row.latitude,
              longitude: row.longitude,
              createdAt: row.createdAt,
              categoryCode: row.categoryCode,
            ),
          )
          .toList(),
    );
  }

  @override
  Future<void> saveFavorite(domain.FavoritePlace place) {
    return _database
        .into(_database.favoritePlaces)
        .insertOnConflictUpdate(
          FavoritePlacesCompanion.insert(
            placeId: place.placeId,
            name: place.name,
            latitude: place.latitude,
            longitude: place.longitude,
            categoryCode: Value(place.categoryCode),
            createdAt: Value(place.createdAt),
          ),
        );
  }

  @override
  Future<void> deleteFavorite(String placeId) {
    return (_database.delete(
      _database.favoritePlaces,
    )..where((row) => row.placeId.equals(placeId))).go();
  }

  @override
  Future<String?> readSetting(String key) async {
    final query = _database.select(_database.appSettings)
      ..where((row) => row.key.equals(key));
    return (await query.getSingleOrNull())?.value;
  }

  @override
  Future<void> writeSetting(String key, String value) {
    return _database
        .into(_database.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: key, value: value),
        );
  }

  @override
  Future<void> deleteSetting(String key) {
    return (_database.delete(
      _database.appSettings,
    )..where((row) => row.key.equals(key))).go();
  }
}
