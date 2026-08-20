import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:gallaemalae/core/config/app_constants.dart';
import 'package:gallaemalae/data/local/tables/app_settings.dart';
import 'package:gallaemalae/data/local/tables/favorite_places.dart';
import 'package:gallaemalae/data/local/tables/festival_cache_entries.dart';
import 'package:gallaemalae/data/local/tables/visit_records.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [VisitRecords, FavoritePlaces, AppSettings, FestivalCacheEntries],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(favoritePlaces, favoritePlaces.categoryCode);
      }
      if (from < 3) {
        await migrator.createTable(festivalCacheEntries);
      }
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
