import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/features/analysis/presentation/views/analysis_page.dart';
import 'package:gallaemalae/features/detail/presentation/views/detail_page.dart';
import 'package:gallaemalae/features/home/presentation/views/home_page.dart';
import 'package:gallaemalae/features/festivals/presentation/views/festival_list_page.dart';
import 'package:gallaemalae/features/favorites/presentation/views/favorite_festivals_page.dart';
import 'package:gallaemalae/features/map/presentation/views/map_page.dart';
import 'package:gallaemalae/features/onboarding/presentation/views/name_entry_page.dart';
import 'package:gallaemalae/features/profile/presentation/views/profile_page.dart';
import 'package:gallaemalae/features/personality/presentation/views/personality_result_page.dart';
import 'package:gallaemalae/features/personality/presentation/views/personality_test_page.dart';
import 'package:gallaemalae/features/splash/presentation/views/splash_page.dart';
import 'package:gallaemalae/features/visits/presentation/views/visit_plans_page.dart';
import 'package:gallaemalae/presentation/views/adaptive_app_shell.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.nameEntry,
        builder: (context, state) => const NameEntryPage(),
      ),
      GoRoute(
        path: AppRoutes.personalityTest,
        builder: (context, state) => const PersonalityTestPage(),
      ),
      GoRoute(
        path: AppRoutes.personalityResult,
        builder: (context, state) => const PersonalityResultPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AdaptiveAppShell(
            currentIndex: _tabIndexFor(state.uri.path),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (_, _) => const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: AppRoutes.map,
            pageBuilder: (_, _) => const NoTransitionPage(child: MapPage()),
          ),
          GoRoute(
            path: AppRoutes.analysis,
            pageBuilder: (_, _) =>
                const NoTransitionPage(child: AnalysisPage()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (_, _) => const NoTransitionPage(child: ProfilePage()),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.festivals,
        pageBuilder: (_, state) =>
            _adaptivePage(key: state.pageKey, child: const FestivalListPage()),
      ),
      GoRoute(
        path: AppRoutes.favoriteFestivals,
        pageBuilder: (_, state) => _adaptivePage(
          key: state.pageKey,
          child: const FavoriteFestivalsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.visitPlans,
        pageBuilder: (_, state) =>
            _adaptivePage(key: state.pageKey, child: const VisitPlansPage()),
      ),
      GoRoute(
        path: '/detail/:placeId',
        pageBuilder: (_, state) => _adaptivePage(
          key: state.pageKey,
          child: DetailPage(placeId: state.pathParameters['placeId']!),
        ),
      ),
    ],
  );
});

Page<void> _adaptivePage({required LocalKey key, required Widget child}) {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return CupertinoPage<void>(key: key, child: child);
  }
  return MaterialPage<void>(key: key, child: child);
}

int _tabIndexFor(String path) => switch (path) {
  AppRoutes.map => 1,
  AppRoutes.analysis => 2,
  AppRoutes.profile => 3,
  _ => 0,
};
