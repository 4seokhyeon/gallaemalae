import 'package:gallaemalae/data/local/app_database.dart';
import 'package:gallaemalae/domain/entities/festival_personality.dart';
import 'package:gallaemalae/domain/repositories/personality_repository.dart';

class DriftPersonalityRepository implements PersonalityRepository {
  DriftPersonalityRepository(this._database);
  static const _key = 'festival_personality_v1';
  final AppDatabase _database;

  @override
  Future<FestivalPersonality?> load() async {
    final query = _database.select(_database.appSettings)
      ..where((row) => row.key.equals(_key));
    final value = (await query.getSingleOrNull())?.value;
    return value == null ? null : FestivalPersonality.decode(value);
  }

  @override
  Future<void> save(FestivalPersonality personality) {
    return _database
        .into(_database.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: _key, value: personality.encode()),
        );
  }

  @override
  Stream<FestivalPersonality?> watch() {
    final query = _database.select(_database.appSettings)
      ..where((row) => row.key.equals(_key));
    return query.watchSingleOrNull().map(
      (row) => row == null ? null : FestivalPersonality.decode(row.value),
    );
  }
}
