import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/features/personality/presentation/view_models/personality_view_model.dart';
import 'package:go_router/go_router.dart';

class PersonalityResultPage extends ConsumerWidget {
  const PersonalityResultPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personality = ref.watch(personalityProvider).value;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                const Text(
                  '갈래말래',
                  style: TextStyle(
                    color: Color(0xFFC93A06),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(26),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x12000000),
                        blurRadius: 24,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD9CD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'ANALYSIS RESULT',
                          style: TextStyle(
                            color: Color(0xFF9F300D),
                            fontSize: 11,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        '성향 테스트 결과 리포트',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFFFF8B68), Color(0xFFFFD1C3)],
                          ),
                        ),
                        child: const Icon(
                          Icons.festival_rounded,
                          color: Colors.white,
                          size: 74,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        personality?.title ?? '성향을 분석하고 있어요',
                        style: const TextStyle(
                          color: Color(0xFFC93A06),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        personality?.description ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF706768),
                          fontSize: 15,
                          height: 1.55,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: _ResultMetric(
                              icon: Icons.groups_rounded,
                              label: '선호 인파',
                              value: personality?.crowdLabel ?? '-',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ResultMetric(
                              icon: Icons.local_fire_department_rounded,
                              label: '방문 시간',
                              value: personality?.periodLabel ?? '-',
                            ),
                          ),
                        ],
                      ),
                      if (personality != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          '선호 콘텐츠  ${personality.categoryLabel}\n'
                          '활동 반경  ${personality.travelScopeLabel}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF706768),
                            fontSize: 12,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: FilledButton(
                    onPressed: personality == null
                        ? null
                        : () => context.go(AppRoutes.home),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFFFF6840),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      '앱 시작하기 🚀',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultMetric extends StatelessWidget {
  const _ResultMetric({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFF3F3F6),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Column(
      children: [
        Icon(icon, color: const Color(0xFFC93A06)),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(color: Color(0xFF817879), fontSize: 11),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );
}
