import 'package:flutter_test/flutter_test.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/features/map/presentation/view_models/map_view_model.dart';

void main() {
  FestivalSummary festival(
    int id,
    double latitude,
    DateTime start,
    DateTime end,
  ) {
    return FestivalSummary(
      id: id,
      title: '$id 축제',
      regionCode: '11',
      startDate: start,
      endDate: end,
      category: FestivalCategory.culture,
      address: '서울',
      latitude: latitude,
      longitude: 127,
      primaryImageUrl: '',
    );
  }

  test('지도 중심에서 가까운 축제를 제한 개수만 선택한다', () {
    final items = [
      festival(1, 37.1, DateTime(2026), DateTime(2027)),
      festival(2, 37.01, DateTime(2026), DateTime(2027)),
      festival(3, 37.2, DateTime(2026), DateTime(2027)),
    ];

    final result = nearestFestivals(
      items,
      latitude: 37,
      longitude: 127,
      limit: 2,
    );

    expect(result.map((item) => item.id), [2, 1]);
  });

  test('축제 시작 전에는 시작일, 진행 중에는 오늘을 분석 날짜로 사용한다', () {
    final upcoming = festival(
      1,
      37,
      DateTime(2026, 9, 1),
      DateTime(2026, 9, 10),
    );
    final ongoing = festival(
      2,
      37,
      DateTime(2026, 8, 1),
      DateTime(2026, 8, 30),
    );

    expect(
      analysisDateForFestival(upcoming, DateTime(2026, 8, 23)),
      DateTime(2026, 9, 1),
    );
    expect(
      analysisDateForFestival(ongoing, DateTime(2026, 8, 23, 14)),
      DateTime(2026, 8, 23),
    );
  });
}
