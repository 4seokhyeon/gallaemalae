import 'package:cupertino_native/components/tab_bar.dart';
import 'package:cupertino_native/style/sf_symbol.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class AdaptiveAppShell extends StatefulWidget {
  const AdaptiveAppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  State<AdaptiveAppShell> createState() => _AdaptiveAppShellState();
}

class _AdaptiveAppShellState extends State<AdaptiveAppShell> {
  DateTime? _lastBackPressedAt;

  void _goToBranch(int index) {
    _lastBackPressedAt = null;
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  Future<bool> _handleAndroidBack() async {
    if (widget.navigationShell.currentIndex != 0) {
      _lastBackPressedAt = null;
      widget.navigationShell.goBranch(0);
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
            Positioned.fill(child: widget.navigationShell),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CNTabBar(
                currentIndex: widget.navigationShell.currentIndex,
                onTap: _goToBranch,
                tint: const Color(0xFFC93A06),
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
            ),
          ],
        ),
      );
    }

    return BackButtonListener(
      onBackButtonPressed: _handleAndroidBack,
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: NavigationBar(
          height: 64,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: widget.navigationShell.currentIndex,
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
