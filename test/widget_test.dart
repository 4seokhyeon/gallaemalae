import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide DayPeriod;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallaemalae/app/app.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/festival_personality.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/domain/entities/favorite_place.dart';
import 'package:gallaemalae/domain/entities/visit.dart';
import 'package:gallaemalae/domain/repositories/festival_repository.dart';
import 'package:gallaemalae/domain/repositories/personality_repository.dart';
import 'package:gallaemalae/domain/repositories/user_activity_repository.dart';
import 'package:gallaemalae/features/analysis/presentation/views/analysis_page.dart';
import 'package:gallaemalae/features/festivals/presentation/view_models/festival_list_view_model.dart';
import 'package:gallaemalae/features/map/presentation/view_models/map_view_model.dart';
import 'package:gallaemalae/features/profile/presentation/views/profile_page.dart';

class _FakePersonalityRepository implements PersonalityRepository {
  _FakePersonalityRepository(this.value);
  FestivalPersonality? value;
  @override
  Future<FestivalPersonality?> load() async => value;
  @override
  Future<void> save(FestivalPersonality personality) async =>
      value = personality;
  @override
  Stream<FestivalPersonality?> watch() => Stream.value(value);
}

class _FakeFestivalRepository implements FestivalRepository {
  static DateTime? lastFrom;
  static DateTime? lastTo;
  static int? lastSize;
  static Set<FestivalCategory>? lastCategories;
  static final requestedPages = <int>[];

  static final festival = FestivalSummary(
    id: 1,
    title: '테스트 축제',
    regionCode: '11',
    startDate: DateTime(2026, 8, 1),
    endDate: DateTime(2026, 8, 31),
    category: FestivalCategory.culture,
    address: '서울특별시',
    latitude: 37.5,
    longitude: 127,
    primaryImageUrl: '',
  );

  static final detail = FestivalDetail(
    id: 1,
    title: '테스트 축제',
    regionCode: '11',
    startDate: DateTime(2026, 8, 1),
    endDate: DateTime(2026, 8, 31),
    category: FestivalCategory.culture,
    externalSource: 'https://example.com',
    address: '서울특별시',
    latitude: 37.5,
    longitude: 127,
    primaryImageUrl: '',
  );

  static final analysis = FestivalAnalysis(
    festivalId: 1,
    predictedFor: DateTime(2026, 8, 20),
    overall: const CrowdPrediction(score: 42, level: CrowdLevel.medium),
    timeSlots: const [
      TimeSlotPrediction(
        period: DayPeriod.morning,
        startTime: '09:00',
        endTime: '12:00',
        score: 25,
        level: CrowdLevel.low,
      ),
    ],
    recommendedPeriod: DayPeriod.morning,
    busiestPeriod: DayPeriod.evening,
    confidence: 0.87,
    basedAt: DateTime.utc(2026, 8, 20, 3, 30),
    factors: const ['날씨', '과거 방문 패턴'],
    dataUpdatedAt: DateTime.utc(2026, 8, 20, 4),
    freshness: DataFreshness.stale,
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
    lastFrom = from;
    lastTo = to;
    lastSize = size;
    lastCategories = categories;
    requestedPages.add(page);
    if (size == 20) {
      return FestivalPage(
        items: [festival.copyWith(id: page + 1, title: '페이지 ${page + 1} 축제')],
        page: page,
        size: size,
        totalElements: 2,
        totalPages: 2,
      );
    }
    return FestivalPage(
      items: [festival],
      page: 0,
      size: size,
      totalElements: 1,
      totalPages: 1,
    );
  }

  @override
  Future<FestivalDetail> getDetail(int id) async => detail;

  @override
  Future<FestivalAnalysis> analyze(int id, DateTime date) async => analysis;
}

class _FakeUserActivityRepository implements UserActivityRepository {
  _FakeUserActivityRepository([Map<String, String>? settings])
    : _settings = {...?settings};

  final Map<String, String> _settings;

  @override
  Future<void> deleteFavorite(String placeId) async {}
  @override
  Future<void> deleteVisit(String id) async {}
  @override
  Future<String?> readSetting(String key) async => _settings[key];
  @override
  Future<void> saveFavorite(FavoritePlace place) async {}
  @override
  Future<void> saveVisit(Visit visit) async {}
  @override
  Stream<List<FavoritePlace>> watchFavorites() => Stream.value(const []);
  @override
  Stream<List<Visit>> watchVisits() => Stream.value(const []);
  @override
  Future<void> writeSetting(String key, String value) async {
    _settings[key] = value;
  }
}

final _completedPersonality = FestivalPersonality(
  type: FestivalPersonalityType.energeticExplorer,
  answers: const [0, 0, 0, 0, 0],
  completedAt: DateTime(2026),
);

Widget _testApp({
  FestivalPersonality? personality,
  bool completed = true,
  bool hasName = true,
}) {
  return ProviderScope(
    overrides: [
      personalityRepositoryProvider.overrideWithValue(
        _FakePersonalityRepository(
          completed ? (personality ?? _completedPersonality) : null,
        ),
      ),
      festivalRepositoryProvider.overrideWithValue(_FakeFestivalRepository()),
      userActivityRepositoryProvider.overrideWithValue(
        _FakeUserActivityRepository(
          hasName ? const {'user_name_v1': '테스트 사용자'} : null,
        ),
      ),
    ],
    child: const GallaeMallaeApp(),
  );
}

Future<void> _pumpThroughSplash(
  WidgetTester tester, {
  FestivalPersonality? personality,
  bool completed = true,
  bool hasName = true,
}) async {
  await tester.pumpWidget(
    _testApp(personality: personality, completed: completed, hasName: hasName),
  );
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pumpAndSettle();
}

void main() {
  test('전체 축제 목록은 다음 페이지를 이어 붙이고 새로고침한다', () async {
    _FakeFestivalRepository.requestedPages.clear();
    final container = ProviderContainer(
      overrides: [
        festivalRepositoryProvider.overrideWithValue(_FakeFestivalRepository()),
        userActivityRepositoryProvider.overrideWithValue(
          _FakeUserActivityRepository(),
        ),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      festivalListViewModelProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);

    await _waitForFestivalList(container);
    expect(container.read(festivalListViewModelProvider).items.length, 1);
    expect(_FakeFestivalRepository.requestedPages, [0]);

    await container.read(festivalListViewModelProvider.notifier).loadMore();
    expect(container.read(festivalListViewModelProvider).items.length, 2);
    expect(_FakeFestivalRepository.requestedPages, [0, 1]);

    await container.read(festivalListViewModelProvider.notifier).refresh();
    expect(container.read(festivalListViewModelProvider).items.length, 1);
    expect(_FakeFestivalRepository.requestedPages, [0, 1, 0]);
  });

  test('축제명 검색 결과를 필터링하고 최근 검색어를 저장한다', () async {
    final activityRepository = _FakeUserActivityRepository();
    final container = ProviderContainer(
      overrides: [
        festivalRepositoryProvider.overrideWithValue(_FakeFestivalRepository()),
        userActivityRepositoryProvider.overrideWithValue(activityRepository),
      ],
    );
    addTearDown(container.dispose);
    final subscription = container.listen(
      festivalListViewModelProvider,
      (_, _) {},
      fireImmediately: true,
    );
    addTearDown(subscription.close);
    await _waitForFestivalList(container);

    await container
        .read(festivalListViewModelProvider.notifier)
        .applyQuery('테스트');

    final state = container.read(festivalListViewModelProvider);
    expect(state.visibleItems.single.title, '테스트 축제');
    expect(state.recentSearches, ['테스트']);
    expect(
      await activityRepository.readSetting('recent_festival_searches_v1'),
      '["테스트"]',
    );
  });

  testWidgets('앱이 정상적으로 시작된다', (tester) async {
    await _pumpThroughSplash(tester);

    expect(find.text('내 취향 축제 추천'), findsOneWidget);
    expect(_FakeFestivalRepository.lastSize, 20);
    expect(
      _FakeFestivalRepository.lastTo!.difference(
        _FakeFestivalRepository.lastFrom!,
      ),
      const Duration(days: 30),
    );
    expect(_FakeFestivalRepository.lastCategories, isEmpty);
  });

  testWidgets('Android 첫 실행 후 첫 뒤로가기는 종료 안내를 표시한다', (tester) async {
    await _pumpThroughSplash(tester);

    await tester.binding.handlePopRoute();
    await tester.pump();

    expect(find.text('내 취향 축제 추천'), findsOneWidget);
    expect(find.text('뒤로가기를 한 번 더 누르면 앱이 종료됩니다.'), findsOneWidget);
  });

  testWidgets('Android 뒤로가기는 다른 탭에서 홈으로 이동한다', (tester) async {
    await _pumpThroughSplash(tester);

    await tester.tap(find.text('지도'));
    await tester.pumpAndSettle();
    expect(find.text('축제 또는 지역 검색'), findsOneWidget);
    expect(_FakeFestivalRepository.lastSize, 100);
    expect(
      _FakeFestivalRepository.lastTo!.difference(
        _FakeFestivalRepository.lastFrom!,
      ),
      const Duration(days: 90),
    );

    final container = ProviderScope.containerOf(
      tester.element(find.text('축제 또는 지역 검색')),
    );
    container.read(mapViewModelProvider.notifier).selectFestival(1);
    await tester.pump();
    expect(find.text('테스트 축제'), findsOneWidget);
    expect(find.text('상세 정보 및 혼잡도 분석'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('내 취향 축제 추천'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.text('뒤로가기를 한 번 더 누르면 앱이 종료됩니다.'), findsOneWidget);
  });

  testWidgets('다른 탭에서 돌아오면 화면 스크롤이 맨 위에서 다시 시작한다', (tester) async {
    await _pumpThroughSplash(tester);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pumpAndSettle();
    final movedPosition = tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .pixels;
    expect(movedPosition, greaterThan(0));

    await tester.tap(find.text('분석'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('홈'));
    await tester.pumpAndSettle();

    final restoredPosition = tester
        .state<ScrollableState>(find.byType(Scrollable).first)
        .position
        .pixels;
    expect(restoredPosition, 0);
    expect(find.text('내 취향 축제 추천'), findsOneWidget);
  });

  testWidgets('현재 선택된 탭을 다시 누르면 최상단으로 이동한다', (tester) async {
    await _pumpThroughSplash(tester);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -700));
    await tester.pumpAndSettle();
    expect(
      tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .pixels,
      greaterThan(0),
    );

    await tester.tap(find.text('홈'));
    await tester.pumpAndSettle();

    expect(
      tester
          .state<ScrollableState>(find.byType(Scrollable).first)
          .position
          .pixels,
      0,
    );
  });

  testWidgets('분석 화면이 작은 화면에서도 넘치지 않는다', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 568);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await _pumpThroughSplash(tester);
    await tester.tap(find.text('분석'));
    await tester.pumpAndSettle();

    expect(find.text('어떤 축제가 궁금하세요?'), findsOneWidget);
    expect(find.text('테스트 축제'), findsOneWidget);
    expect(_FakeFestivalRepository.lastSize, 5);
    expect(
      _FakeFestivalRepository.lastTo!.difference(
        _FakeFestivalRepository.lastFrom!,
      ),
      const Duration(days: 90),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('분석 결과에 데이터 상태와 갱신 정보를 표시한다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          festivalRepositoryProvider.overrideWithValue(
            _FakeFestivalRepository(),
          ),
          userActivityRepositoryProvider.overrideWithValue(
            _FakeUserActivityRepository({
              'analysis_selection_v1':
                  '{"festivalId":1,"visitDate":"2026-08-20"}',
            }),
          ),
        ],
        child: const MaterialApp(home: AnalysisPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('업데이트 지연'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('가장 혼잡한 시간: 저녁'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('가장 혼잡한 시간: 저녁'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.textContaining('데이터 업데이트:'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('예측 기준 시각:'), findsOneWidget);
    expect(find.textContaining('데이터 업데이트:'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  for (final size in <Size>[const Size(320, 568), const Size(430, 932)]) {
    testWidgets('${size.width.toInt()}x${size.height.toInt()} 화면에서 넘치지 않는다', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await _pumpThroughSplash(tester);

      expect(find.text('내 취향 축제 추천'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('첫 실행 사용자는 성향 테스트로 이동한다', (tester) async {
    await _pumpThroughSplash(tester, completed: false);

    expect(find.text('QUESTION 01'), findsOneWidget);
    expect(find.text('축제의 분위기, 당신의 선택은?'), findsOneWidget);
  });

  testWidgets('이름이 없는 첫 실행 사용자는 이름 입력 후 성향 테스트로 이동한다', (tester) async {
    await _pumpThroughSplash(tester, completed: false, hasName: false);

    expect(find.text('어떻게 불러드릴까요?'), findsOneWidget);
    await tester.enterText(find.byType(TextFormField), '홍길동');
    await tester.tap(find.text('성향 테스트 시작하기'));
    await tester.pumpAndSettle();

    expect(find.text('QUESTION 01'), findsOneWidget);
  });

  testWidgets('iOS 이름 입력 화면은 MaterialLocalizations 오류 없이 렌더링된다', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await _pumpThroughSplash(tester, completed: false, hasName: false);

    expect(find.text('어떻게 불러드릴까요?'), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(tester.takeException(), isNull);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('프로필에서 저장된 축제 성향을 표시하고 재검사를 시작한다', (tester) async {
    await _pumpThroughSplash(tester);

    await tester.tap(find.text('프로필'));
    await tester.pumpAndSettle();
    expect(find.text('테스트 사용자 님'), findsOneWidget);
    expect(find.text('열정적인 축제 탐험가'), findsOneWidget);

    await tester.tap(find.text('다시 테스트하기'));
    await tester.pumpAndSettle();
    expect(find.text('QUESTION 01'), findsOneWidget);
  });

  testWidgets('iOS 분석 화면은 MaterialLocalizations 없이 렌더링된다', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          festivalRepositoryProvider.overrideWithValue(
            _FakeFestivalRepository(),
          ),
          userActivityRepositoryProvider.overrideWithValue(
            _FakeUserActivityRepository(),
          ),
        ],
        child: const CupertinoApp(home: AnalysisPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('혼잡도 분석'), findsOneWidget);
    expect(find.text('어떤 축제가 궁금하세요?'), findsOneWidget);
    final exception = tester.takeException();
    debugDefaultTargetPlatformOverride = null;
    expect(exception, isNull);
  });

  testWidgets('iOS 프로필 설정 스위치는 Material 조상 없이 렌더링된다', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          personalityRepositoryProvider.overrideWithValue(
            _FakePersonalityRepository(_completedPersonality),
          ),
        ],
        child: const CupertinoApp(home: ProfilePage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('실시간 혼잡도 알림'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();

    final switchCount = find.byType(CupertinoSwitch).evaluate().length;
    final exception = tester.takeException();
    debugDefaultTargetPlatformOverride = null;

    expect(switchCount, 1);
    expect(exception, isNull);
  });
}

Future<void> _waitForFestivalList(ProviderContainer container) async {
  for (var attempt = 0; attempt < 20; attempt++) {
    if (!container.read(festivalListViewModelProvider).isInitialLoading) return;
    await Future<void>.delayed(Duration.zero);
  }
  fail('축제 목록 초기 로딩이 완료되지 않았습니다.');
}
