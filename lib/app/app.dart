import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/router/app_router.dart';
import 'package:gallaemalae/core/theme/cupertino_app_theme.dart';
import 'package:gallaemalae/core/theme/material_app_theme.dart';

class GallaeMallaeApp extends ConsumerWidget {
  const GallaeMallaeApp({super.key});

  static const _locale = Locale('ko', 'KR');
  static const _supportedLocales = [_locale, Locale('en', 'US')];
  static const _localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    if (isIOS) {
      return CupertinoApp.router(
        title: '갈래말래',
        debugShowCheckedModeBanner: false,
        theme: CupertinoAppTheme.light,
        locale: _locale,
        supportedLocales: _supportedLocales,
        localizationsDelegates: _localizationsDelegates,
        routerConfig: router,
      );
    }

    return MaterialApp.router(
      title: '갈래말래',
      debugShowCheckedModeBanner: false,
      theme: MaterialAppTheme.light,
      darkTheme: MaterialAppTheme.dark,
      locale: _locale,
      supportedLocales: _supportedLocales,
      localizationsDelegates: _localizationsDelegates,
      routerConfig: router,
    );
  }
}
