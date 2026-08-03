import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/features/analysis/presentation/views/analysis_page.dart';
import 'package:gallaemalae/features/detail/presentation/views/detail_page.dart';
import 'package:gallaemalae/features/home/presentation/views/home_page.dart';
import 'package:gallaemalae/features/map/presentation/views/map_page.dart';
import 'package:gallaemalae/features/profile/presentation/views/profile_page.dart';
import 'package:gallaemalae/presentation/views/adaptive_app_shell.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdaptiveAppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.map,
                builder: (context, state) => const MapPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.analysis,
                builder: (context, state) => const AnalysisPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
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
