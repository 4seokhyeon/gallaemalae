import 'package:gallaemalae/data/local/app_database.dart';

class FestivalCacheStore {
  const FestivalCacheStore(this._database);
  final AppDatabase _database;

  Future<void> write(String key, String payload) {
    return _database
        .into(_database.festivalCacheEntries)
        .insertOnConflictUpdate(
          FestivalCacheEntriesCompanion.insert(
            cacheKey: key,
            payload: payload,
            cachedAt: DateTime.now(),
          ),
        );
  }

  Future<String?> read(String key) async {
    final query = _database.select(_database.festivalCacheEntries)
      ..where((row) => row.cacheKey.equals(key));
    return (await query.getSingleOrNull())?.payload;
  }
}
