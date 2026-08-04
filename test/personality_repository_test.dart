import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallaemalae/data/local/app_database.dart';
import 'package:gallaemalae/data/repositories/drift_personality_repository.dart';
import 'package:gallaemalae/domain/entities/festival_personality.dart';

void main() {
  test('Drift에 축제 성향을 저장하고 다시 불러온다', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftPersonalityRepository(database);
    final personality = FestivalPersonality(
      type: FestivalPersonalityType.energeticExplorer,
      answers: const [0, 1, 0, 0, 1],
      completedAt: DateTime(2026, 8, 4),
    );

    await repository.save(personality);
    final restored = await repository.load();

    expect(restored?.type, FestivalPersonalityType.energeticExplorer);
    expect(restored?.answers, [0, 1, 0, 0, 1]);
    expect(restored?.apiCode, 'ENERGETIC_EXPLORER');
  });
}
