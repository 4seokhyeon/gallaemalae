import 'package:flutter_test/flutter_test.dart';
import 'package:gallaemalae/domain/entities/visit.dart';
import 'package:gallaemalae/features/analysis/presentation/view_models/analysis_view_model.dart';

void main() {
  Visit plan(String id, DateTime date) => Visit(
    id: 'planned_$id',
    placeId: id,
    placeName: '$id 축제',
    visitedAt: date,
    crowdLevel: 50,
  );

  test('오늘 이후 방문 일정 중 가장 가까운 일정을 선택한다', () {
    final result = nearestUpcomingPlan([
      plan('1', DateTime(2026, 8, 19)),
      plan('2', DateTime(2026, 8, 25)),
      plan('3', DateTime(2026, 8, 22)),
    ], DateTime(2026, 8, 20, 15));

    expect(result?.placeId, '3');
  });

  test('지난 일정과 일반 방문 기록은 분석 자동 선택에서 제외한다', () {
    final result = nearestUpcomingPlan([
      plan('1', DateTime(2026, 8, 19)),
      Visit(
        id: 'history_2',
        placeId: '2',
        placeName: '방문 완료 축제',
        visitedAt: DateTime(2026, 8, 25),
        crowdLevel: 30,
      ),
    ], DateTime(2026, 8, 20));

    expect(result, isNull);
  });
}
