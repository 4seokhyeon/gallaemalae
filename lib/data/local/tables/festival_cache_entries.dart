import 'package:drift/drift.dart';

class FestivalCacheEntries extends Table {
  TextColumn get cacheKey => text()();
  TextColumn get payload => text()();
  DateTimeColumn get cachedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {cacheKey};
}
