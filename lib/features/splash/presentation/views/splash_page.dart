import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});
  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future<void>(() async {
      final personality = await ref.read(personalityRepositoryProvider).load();
      await Future<void>.delayed(const Duration(milliseconds: 550));
      if (!mounted) return;
      context.go(
        personality == null ? AppRoutes.personalityTest : AppRoutes.home,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFC93A06),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.festival_rounded, color: Colors.white, size: 70),
            SizedBox(height: 18),
            Text(
              '갈래말래',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 10),
            Text(
              '나에게 꼭 맞는 축제를 찾아드려요',
              style: TextStyle(color: Color(0xDDFFFFFF), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
