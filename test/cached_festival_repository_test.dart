import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallaemalae/data/local/app_database.dart';
import 'package:gallaemalae/data/local/cache/festival_cache_store.dart';
import 'package:gallaemalae/data/repositories/cached_festival_repository.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/domain/repositories/festival_repository.dart';

void main() {
  test('API 성공 데이터를 저장하고 실패하면 Drift 캐시를 반환한다', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final remote = _ToggleFestivalRepository();
    final repository = CachedFestivalRepository(
      remote,
      FestivalCacheStore(database),
    );
    final from = DateTime(2026, 8, 20);
    final to = DateTime(2026, 9, 20);

    final onlinePage = await repository.search(from: from, to: to);
    final onlineDetail = await repository.getDetail(1);
    final onlineAnalysis = await repository.analyze(1, from);
    remote.shouldFail = true;
    final cachedPage = await repository.search(from: from, to: to);
    final cachedDetail = await repository.getDetail(1);
    final cachedAnalysis = await repository.analyze(1, from);

    expect(cachedPage, onlinePage);
    expect(cachedDetail, onlineDetail);
    expect(cachedAnalysis.overall, onlineAnalysis.overall);
    expect(cachedAnalysis.freshness, DataFreshness.stale);
  });

  test('저장된 캐시가 없으면 API 오류를 그대로 전달한다', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final remote = _ToggleFestivalRepository()..shouldFail = true;
    final repository = CachedFestivalRepository(
      remote,
      FestivalCacheStore(database),
    );

    expect(repository.getDetail(99), throwsStateError);
  });
}

class _ToggleFestivalRepository implements FestivalRepository {
  bool shouldFail = false;

  static final summary = FestivalSummary(
    id: 1,
    title: '캐시 축제',
    regionCode: '11',
    startDate: DateTime(2026, 8, 20),
    endDate: DateTime(2026, 9, 20),
    category: FestivalCategory.culture,
    address: '서울',
    latitude: 37.5,
    longitude: 127,
    primaryImageUrl: '',
  );

  static final detail = FestivalDetail(
    id: 1,
    title: '캐시 축제',
    regionCode: '11',
    startDate: DateTime(2026, 8, 20),
    endDate: DateTime(2026, 9, 20),
    category: FestivalCategory.culture,
    externalSource: 'https://example.com',
    address: '서울',
    latitude: 37.5,
    longitude: 127,
    primaryImageUrl: '',
  );

  @override
  Future<FestivalPage> search({
    String? regionCode,
    DateTime? from,
    DateTime? to,
    Set<FestivalCategory> categories = const {},
    int page = 0,
    int size = 20,
  }) async {
    if (shouldFail) throw StateError('offline');
    return FestivalPage(
      items: [summary],
      page: page,
      size: size,
      totalElements: 1,
      totalPages: 1,
    );
  }

  @override
  Future<FestivalDetail> getDetail(int id) async {
    if (shouldFail) throw StateError('offline');
    return detail;
  }

  @override
  Future<FestivalAnalysis> analyze(int id, DateTime date) async {
    if (shouldFail) throw StateError('offline');
    return FestivalAnalysis(
      festivalId: id,
      predictedFor: date,
      overall: const CrowdPrediction(score: 42, level: CrowdLevel.medium),
      timeSlots: const [
        TimeSlotPrediction(
          period: DayPeriod.morning,
          startTime: '09:00',
          endTime: '12:00',
          score: 30,
          level: CrowdLevel.low,
        ),
      ],
      recommendedPeriod: DayPeriod.morning,
      busiestPeriod: DayPeriod.evening,
      confidence: .8,
      basedAt: DateTime(2026, 8, 19),
      factors: const ['날씨'],
      dataUpdatedAt: DateTime(2026, 8, 19),
      freshness: DataFreshness.fresh,
    );
  }
}
