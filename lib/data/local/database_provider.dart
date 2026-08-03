import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/data/local/app_database.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});
