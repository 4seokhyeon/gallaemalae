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
        builder: (context, state) => const FestivalListPage(),
      ),
      GoRoute(
        path: AppRoutes.favoriteFestivals,
        builder: (context, state) => const FavoriteFestivalsPage(),
      ),
      GoRoute(
        path: AppRoutes.visitPlans,
        builder: (context, state) => const VisitPlansPage(),
      ),
      GoRoute(
        path: '/detail/:placeId',
        builder: (context, state) {
          return DetailPage(placeId: state.pathParameters['placeId']!);
        },
      ),
    ],
  );
});

int _tabIndexFor(String path) => switch (path) {
  AppRoutes.map => 1,
  AppRoutes.analysis => 2,
  AppRoutes.profile => 3,
  _ => 0,
};
