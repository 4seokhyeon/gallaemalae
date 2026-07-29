import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gallaemalae/main.dart';

void main() {
  testWidgets('앱이 정상적으로 시작된다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: GallaeMallaeApp()));

    expect(find.text('갈래말래'), findsOneWidget);
  });
}
