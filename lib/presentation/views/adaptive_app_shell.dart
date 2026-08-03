import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdaptiveAppShell extends StatelessWidget {
  const AdaptiveAppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _goToBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageScaffold(
        child: Stack(
          children: [
            Positioned.fill(child: navigationShell),
            Align(
              alignment: Alignment.bottomCenter,
              child: CupertinoTabBar(
                currentIndex: navigationShell.currentIndex,
                onTap: _goToBranch,
                backgroundColor: CupertinoColors.systemBackground
                    .resolveFrom(context)
                    .withValues(alpha: 0.82),
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.house_fill),
                    label: '홈',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.map_fill),
                    label: '지도',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.chart_bar_fill),
                    label: '분석',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.person_crop_circle_fill),
                    label: '프로필',
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goToBranch,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: '홈'),
          NavigationDestination(icon: Icon(Icons.map_outlined), label: '지도'),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            label: '분석',
          ),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '프로필'),
        ],
      ),
    );
  }
}
