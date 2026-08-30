import 'package:cupertino_native/components/tab_bar.dart';
import 'package:cupertino_native/style/sf_symbol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallaemalae/core/navigation/tab_reselection.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:go_router/go_router.dart';

class AdaptiveAppShell extends StatefulWidget {
  const AdaptiveAppShell({
    required this.currentIndex,
    required this.child,
    super.key,
  });

  final int currentIndex;
  final Widget child;

  @override
  State<AdaptiveAppShell> createState() => _AdaptiveAppShellState();
}

class _AdaptiveAppShellState extends State<AdaptiveAppShell> {
  static const _tabPaths = [
    AppRoutes.home,
    AppRoutes.map,
    AppRoutes.analysis,
    AppRoutes.profile,
  ];
  DateTime? _lastBackPressedAt;

  void _goToBranch(int index) {
    _lastBackPressedAt = null;
    if (index == widget.currentIndex) {
      TabReselectionEvent.instance.notify(index);
      return;
    }
    context.go(_tabPaths[index]);
  }

  Future<bool> _handleAndroidBack() async {
    final router = GoRouter.of(context);
    final currentPath = router.routerDelegate.currentConfiguration.uri.path;
    if (router.canPop()) {
      _lastBackPressedAt = null;
      router.pop();
      return true;
    }

    if (!_tabPaths.contains(currentPath)) {
      _lastBackPressedAt = null;
      context.go(AppRoutes.home);
      return true;
    }

    if (widget.currentIndex != 0) {
      _lastBackPressedAt = null;
      context.go(AppRoutes.home);
      return true;
    }

    final now = DateTime.now();
    final shouldShowGuide =
        _lastBackPressedAt == null ||
        now.difference(_lastBackPressedAt!) > const Duration(seconds: 2);

    if (shouldShowGuide) {
      _lastBackPressedAt = now;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('뒤로가기를 한 번 더 누르면 앱이 종료됩니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      return true;
    }

    await SystemNavigator.pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageScaffold(
        child: Stack(
          children: [
            Positioned.fill(child: widget.child),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _IOSNativeTabBar(
                currentIndex: widget.currentIndex,
                onTap: _goToBranch,
              ),
            ),
          ],
        ),
      );
    }

    return BackButtonListener(
      onBackButtonPressed: _handleAndroidBack,
      child: Scaffold(
        body: widget.child,
        bottomNavigationBar: NavigationBar(
          height: 64,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: widget.currentIndex,
          onDestinationSelected: _goToBranch,
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
            NavigationDestination(icon: Icon(Icons.map_outlined), label: '지도'),
            NavigationDestination(
              icon: Icon(Icons.analytics_outlined),
              label: '분석',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              label: '프로필',
            ),
          ],
        ),
      ),
    );
  }
}

class _IOSNativeTabBar extends StatelessWidget {
  const _IOSNativeTabBar({required this.currentIndex, required this.onTap});

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerUp: (event) {
            if (constraints.maxWidth <= 0) return;
            final tappedIndex =
                (event.localPosition.dx / constraints.maxWidth * 4)
                    .floor()
                    .clamp(0, 3);
            // CNTabBar는 선택된 탭 재탭 콜백을 보내지 않으므로 스크롤을
            // 최상단으로 이동시키는 동작만 Flutter 포인터 단계에서 보완합니다.
            if (tappedIndex == currentIndex) onTap(tappedIndex);
          },
          child: CNTabBar(
            currentIndex: currentIndex,
            onTap: onTap,
            tint: const Color(0xFFC93A06),
            shrinkCentered: false,
            items: const [
              CNTabBarItem(icon: CNSymbol('house.fill'), label: '홈'),
              CNTabBarItem(icon: CNSymbol('map.fill'), label: '지도'),
              CNTabBarItem(icon: CNSymbol('chart.bar.fill'), label: '분석'),
              CNTabBarItem(
                icon: CNSymbol('person.crop.circle.fill'),
                label: '프로필',
              ),
            ],
          ),
        );
      },
    );
  }
}
