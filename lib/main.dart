import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/app/app.dart';
import 'package:gallaemalae/core/config/app_env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (AppEnv.hasNaverMapClientId) {
    await FlutterNaverMap().init(
      clientId: AppEnv.naverMapClientId,
      onAuthFailed: (exception) {
        debugPrint('네이버 지도 인증 실패: $exception');
      },
    );
  }

  runApp(const ProviderScope(child: GallaeMallaeApp()));
}
