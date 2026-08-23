import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallaemalae/data/local/app_database.dart';
import 'package:gallaemalae/data/repositories/drift_personality_repository.dart';
import 'package:gallaemalae/data/repositories/drift_user_activity_repository.dart';
import 'package:gallaemalae/domain/entities/favorite_place.dart' as domain;
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/domain/entities/visit.dart' as domain;
import 'package:gallaemalae/domain/entities/festival_personality.dart';

void main() {
  test('4문항 추천 성향을 API 필터 값으로 변환한다', () {
    final personality = FestivalPersonality(
      type: FestivalPersonalityType.energeticExplorer,
      answers: const [6, 0, 2, 1],
      completedAt: DateTime(2026),
      preferredCategories: const {
        FestivalCategory.food,
        FestivalCategory.performance,
      },
      crowdPreference: FestivalCrowdPreference.lively,
      preferredPeriod: DayPeriod.evening,
      travelScope: FestivalTravelScope.nearby,
    );

    expect(personality.apiCategories, {
      FestivalCategory.food,
      FestivalCategory.performance,
    });
    expect(personality.crowdLabel, '활기찬 인파');
    expect(personality.periodLabel, '저녁');
    expect(personality.travelScopeLabel, '인접 지역');
  });

  test('Drift에 축제 성향을 저장하고 다시 불러온다', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftPersonalityRepository(database);
    final personality = FestivalPersonality(
      type: FestivalPersonalityType.energeticExplorer,
      answers: const [6, 0, 2, 1],
      completedAt: DateTime(2026, 8, 4),
      preferredCategories: const {
        FestivalCategory.food,
        FestivalCategory.performance,
      },
      crowdPreference: FestivalCrowdPreference.lively,
      preferredPeriod: DayPeriod.evening,
      travelScope: FestivalTravelScope.nearby,
    );

    await repository.save(personality);
    final restored = await repository.load();

    expect(restored?.type, FestivalPersonalityType.energeticExplorer);
    expect(restored?.answers, [6, 0, 2, 1]);
    expect(restored?.preferredCategories, {
      FestivalCategory.food,
      FestivalCategory.performance,
    });
    expect(restored?.apiCode, 'ENERGETIC_EXPLORER');
  });

  test('Drift에 관심 축제를 저장하고 삭제한다', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftUserActivityRepository(database);
    final favorite = domain.FavoritePlace(
      placeId: '101',
      name: '테스트 축제',
      latitude: 37.5,
      longitude: 127,
      createdAt: DateTime(2026, 8, 20),
      categoryCode: 'culture',
    );

    await repository.saveFavorite(favorite);
    expect(await repository.watchFavorites().first, [favorite]);

    await repository.deleteFavorite(favorite.placeId);
    expect(await repository.watchFavorites().first, isEmpty);
  });

  test('Drift에 방문 예정일을 저장하고 다시 불러온다', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftUserActivityRepository(database);
    final visit = domain.Visit(
      id: 'planned_101',
      placeId: '101',
      placeName: '테스트 축제',
      visitedAt: DateTime(2026, 8, 25),
      crowdLevel: 42,
    );

    await repository.saveVisit(visit);

    expect(await repository.watchVisits().first, [visit]);
  });

  test('Drift 설정에 사용자 이름을 저장하고 다시 불러온다', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftUserActivityRepository(database);

    await repository.writeSetting('user_name_v1', '홍길동');

    expect(await repository.readSetting('user_name_v1'), '홍길동');
  });
}
