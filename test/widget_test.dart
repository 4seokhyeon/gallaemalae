import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallaemalae/app/app.dart';

void main() {
  testWidgets('앱이 정상적으로 시작된다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: GallaeMallaeApp()));

    expect(find.text('오늘의 AI 맞춤 추천'), findsOneWidget);
  });

  testWidgets('Android 첫 실행 후 첫 뒤로가기는 종료 안내를 표시한다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: GallaeMallaeApp()));

    await tester.binding.handlePopRoute();
    await tester.pump();

    expect(find.text('오늘의 AI 맞춤 추천'), findsOneWidget);
    expect(find.text('뒤로가기를 한 번 더 누르면 앱이 종료됩니다.'), findsOneWidget);
  });

  testWidgets('Android 뒤로가기는 다른 탭에서 홈으로 이동한다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: GallaeMallaeApp()));

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

  for (final size in <Size>[const Size(320, 568), const Size(430, 932)]) {
    testWidgets('${size.width.toInt()}x${size.height.toInt()} 화면에서 넘치지 않는다', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const ProviderScope(child: GallaeMallaeApp()));
      await tester.pump();

      expect(find.text('오늘의 AI 맞춤 추천'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
