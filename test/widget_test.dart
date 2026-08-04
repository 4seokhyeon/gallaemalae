import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallaemalae/app/app.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/festival_personality.dart';
import 'package:gallaemalae/domain/repositories/personality_repository.dart';
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

final _completedPersonality = FestivalPersonality(
  type: FestivalPersonalityType.energeticExplorer,
  answers: const [0, 0, 0, 0, 0],
  completedAt: DateTime(2026),
);

Widget _testApp({FestivalPersonality? personality, bool completed = true}) {
  return ProviderScope(
    overrides: [
      personalityRepositoryProvider.overrideWithValue(
        _FakePersonalityRepository(
          completed ? (personality ?? _completedPersonality) : null,
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
}) async {
  await tester.pumpWidget(
    _testApp(personality: personality, completed: completed),
  );
  await tester.pump(const Duration(milliseconds: 600));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('앱이 정상적으로 시작된다', (tester) async {
    await _pumpThroughSplash(tester);

    expect(find.text('오늘의 AI 맞춤 추천'), findsOneWidget);
  });

  testWidgets('Android 첫 실행 후 첫 뒤로가기는 종료 안내를 표시한다', (tester) async {
    await _pumpThroughSplash(tester);

    await tester.binding.handlePopRoute();
    await tester.pump();

    expect(find.text('오늘의 AI 맞춤 추천'), findsOneWidget);
    expect(find.text('뒤로가기를 한 번 더 누르면 앱이 종료됩니다.'), findsOneWidget);
  });

  testWidgets('Android 뒤로가기는 다른 탭에서 홈으로 이동한다', (tester) async {
    await _pumpThroughSplash(tester);

    await tester.tap(find.text('지도'));
    await tester.pumpAndSettle();
    expect(find.text('축제 또는 지역 검색'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.text('오늘의 AI 맞춤 추천'), findsOneWidget);

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
    expect(find.text('오늘의 AI 맞춤 추천'), findsOneWidget);
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

    expect(find.text('서울 불꽃 축제 2024'), findsOneWidget);
    expect(find.byTooltip('공유하기'), findsOneWidget);
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

      expect(find.text('오늘의 AI 맞춤 추천'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('첫 실행 사용자는 성향 테스트로 이동한다', (tester) async {
    await _pumpThroughSplash(tester, completed: false);

    expect(find.text('QUESTION 01'), findsOneWidget);
    expect(find.text('축제의 분위기, 당신의 선택은?'), findsOneWidget);
  });

  testWidgets('프로필에서 저장된 축제 성향을 표시하고 재검사를 시작한다', (tester) async {
    await _pumpThroughSplash(tester);

    await tester.tap(find.text('프로필'));
    await tester.pumpAndSettle();
    expect(find.text('열정적인 축제 탐험가'), findsOneWidget);

    await tester.tap(find.text('다시 테스트하기'));
    await tester.pumpAndSettle();
    expect(find.text('QUESTION 01'), findsOneWidget);
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
