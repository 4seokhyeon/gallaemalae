import 'package:flutter_test/flutter_test.dart';
import 'package:gallaemalae/domain/entities/favorite_place.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/domain/entities/festival_personality.dart';
import 'package:gallaemalae/features/home/presentation/view_models/home_view_model.dart';

void main() {
  FestivalSummary festival(int id, FestivalCategory category, int day) {
    return FestivalSummary(
      id: id,
      title: '$category 축제',
      regionCode: '11',
      startDate: DateTime(2026, 9, day),
      endDate: DateTime(2026, 9, day + 1),
      category: category,
      address: '서울',
      latitude: 37.5,
      longitude: 127,
      primaryImageUrl: '',
    );
  }

  test('관심 축제 카테고리를 성향보다 높은 우선순위로 추천한다', () {
    final ranked = rankHomeRecommendations(
      [
        festival(1, FestivalCategory.performance, 1),
        festival(2, FestivalCategory.nature, 3),
        festival(3, FestivalCategory.culture, 2),
      ],
      preferredCategories: const {FestivalCategory.performance},
      favoriteCategoryCounts: const {FestivalCategory.nature: 1},
    );

    expect(ranked.map((item) => item.id), [2, 1, 3]);
  });

  test('Drift 관심 축제에서 유효한 카테고리 빈도를 계산한다', () {
    final favorites = [
      FavoritePlace(
        placeId: '1',
        name: '자연 축제 1',
        latitude: 0,
        longitude: 0,
        createdAt: DateTime(2026),
        categoryCode: FestivalCategory.nature.name,
      ),
      FavoritePlace(
        placeId: '2',
        name: '자연 축제 2',
        latitude: 0,
        longitude: 0,
        createdAt: DateTime(2026),
        categoryCode: FestivalCategory.nature.name,
      ),
      FavoritePlace(
        placeId: '3',
        name: '기존 데이터',
        latitude: 0,
        longitude: 0,
        createdAt: DateTime(2026),
      ),
    ];

    expect(favoriteCategoryCounts(favorites), {FestivalCategory.nature: 2});
  });

  test('성향과 일치한 대표 축제의 구체적인 추천 이유를 만든다', () {
    final reason = homeRecommendationReason(
      festival(1, FestivalCategory.performance, 1),
      personality: FestivalPersonality(
        type: FestivalPersonalityType.energeticExplorer,
        answers: const [0, 0, 0, 0, 0],
        completedAt: DateTime(2026),
      ),
      favoriteCategoryCounts: const {},
    );

    expect(reason, contains('활기찬 탐험가'));
    expect(reason, contains('공연 유형'));
  });
}
