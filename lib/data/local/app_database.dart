import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:gallaemalae/core/config/app_constants.dart';
import 'package:gallaemalae/data/local/tables/app_settings.dart';
import 'package:gallaemalae/data/local/tables/favorite_places.dart';
import 'package:gallaemalae/data/local/tables/visit_records.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [VisitRecords, FavoritePlaces, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File(p.join(directory.path, AppConstants.databaseName));
    return NativeDatabase.createInBackground(file);
  });
}
