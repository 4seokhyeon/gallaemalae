import 'package:flutter_test/flutter_test.dart';
import 'package:gallaemalae/data/repositories/api_festival_repository.dart';
import 'package:gallaemalae/domain/entities/festival.dart';

void main() {
  test('혼잡도 API의 객체 배열과 문자열 factors 배열을 함께 파싱한다', () {
    final analysis = festivalAnalysisFromApi({
      'festivalId': 131,
      'predictedFor': '2026-08-01',
      'overall': {'score': 99, 'level': 'VERY_HIGH'},
      'timeSlots': [
        {
          'period': 'MORNING',
          'startTime': '09:00:00',
          'endTime': '12:00:00',
          'score': 89,
          'level': 'VERY_HIGH',
        },
      ],
      'recommendedPeriod': 'MORNING',
      'busiestPeriod': 'AFTERNOON',
      'confidence': 0.13,
      'basedAt': '2026-08-23T05:19:49.317554575Z',
      'factors': ['HISTORICAL_VISITORS', 'TIME_SLOT_HEURISTIC'],
      'dataUpdatedAt': '2026-08-23T05:15:09.246412Z',
      'freshness': 'FRESH',
    });

    expect(analysis.overall.score, 99);
    expect(analysis.overall.level, CrowdLevel.veryHigh);
    expect(analysis.timeSlots.single.startTime, '09:00');
    expect(analysis.timeSlots.single.endTime, '12:00');
    expect(analysis.factors, ['과거 방문객 데이터', '시간대별 혼잡 패턴']);
  });

  test('UNAVAILABLE 응답의 null 분석 필드를 안전하게 처리한다', () {
    final analysis = festivalAnalysisFromApi({
      'festivalId': 57,
      'predictedFor': '2026-08-23',
      'overall': null,
      'timeSlots': <Object?>[],
      'recommendedPeriod': null,
      'busiestPeriod': null,
      'confidence': 0,
      'basedAt': '2026-08-23T03:31:26Z',
      'factors': <Object?>[],
      'dataUpdatedAt': null,
      'freshness': 'UNAVAILABLE',
    });

    expect(analysis.freshness, DataFreshness.unavailable);
    expect(analysis.timeSlots, isEmpty);
    expect(analysis.dataUpdatedAt, analysis.basedAt);
  });
}
