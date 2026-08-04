import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/layout/app_layout.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/features/personality/presentation/view_models/personality_view_model.dart';
import 'package:go_router/go_router.dart';

const _brand = Color(0xFFC93A06);
const _orange = Color(0xFFFF6840);
const _ink = Color(0xFF29262C);
const _muted = Color(0xFF776E6D);

class _Question {
  const _Question(this.title, this.subtitle, this.options, this.icon);
  final String title;
  final String subtitle;
  final List<String> options;
  final IconData icon;
}

const _questions = [
  _Question('축제의 분위기, 당신의 선택은?', '어떤 소음이 더 즐거운가요?', [
    '에너지 넘치는 시끌벅적한 축제',
    '고즈넉하고 조용한 감성 축제',
  ], Icons.celebration_rounded),
  _Question(
    '축제에서 가장 기대되는 순간은 언제인가요?',
    '마음이 먼저 향하는 장면을 골라주세요.',
    ['화려한 무대 공연과 열광적인 환호', '로컬 음식을 맛보며 즐기는 여유로운 산책'],
    Icons.theater_comedy_rounded,
  ),
  _Question('함께 축제를 즐기고 싶은 파트너는 누구인가요?', '가장 설레는 축제의 순간을 상상해 보세요.', [
    '처음 본 사람들과도 친구가 되는 북적이는 모임',
    '마음이 잘 맞는 소수의 친구나 연인',
  ], Icons.groups_rounded),
  _Question('축제 장소를 선택할 때 가장 중요한 기준은?', '당신의 직감을 믿고 선택해보세요.', [
    '최신 트렌드와 화제성',
    '전통과 깊은 의미',
  ], Icons.explore_rounded),
  _Question(
    '축제에서 가장 중요하게 생각하는 가치는?',
    '당신의 축제 성향을 결정짓는 마지막 관문입니다.',
    ['새로운 사람들과의 만남과 에너지', '나만의 온전한 휴식과 감성 충전'],
    Icons.auto_awesome_rounded,
  ),
];

class PersonalityTestPage extends ConsumerStatefulWidget {
  const PersonalityTestPage({super.key});
  @override
  ConsumerState<PersonalityTestPage> createState() =>
      _PersonalityTestPageState();
}

class _PersonalityTestPageState extends ConsumerState<PersonalityTestPage> {
  int _index = 0;
  bool _saving = false;

  Future<void> _next() async {
    if (_index < _questions.length - 1) {
      setState(() => _index++);
      return;
    }
    setState(() => _saving = true);
    await ref.read(personalityTestControllerProvider.notifier).complete();
    if (mounted) context.go(AppRoutes.personalityResult);
  }

  void _back() {
    if (_index > 0) {
      setState(() => _index--);
    } else if (context.canPop()) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final answers = ref.watch(personalityTestControllerProvider);
    final selected = answers[_index];
    final question = _questions[_index];
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FB),
      body: SafeArea(
        child: ResponsiveContent(
          maxWidth: 520,
          child: Column(
            children: [
              SizedBox(
                height: 56,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: _back,
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          '갈래말래',
                          style: TextStyle(
                            color: _brand,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '${_index + 1} / ${_questions.length}',
                      style: const TextStyle(
                        color: _muted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 28, 0, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'QUESTION ${(_index + 1).toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              color: _brand,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.3,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${((_index + 1) * 20)}%',
                            style: const TextStyle(color: _muted, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: (_index + 1) / 5,
                          minHeight: 8,
                          color: _orange,
                          backgroundColor: const Color(0xFFE6E6E9),
                        ),
                      ),
                      const SizedBox(height: 28),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE5DD),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Icon(question.icon, color: _brand),
                            ),
                            const SizedBox(height: 17),
                            Text(
                              question.title,
                              style: const TextStyle(
                                color: _ink,
                                fontSize: 23,
                                height: 1.25,
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              question.subtitle,
                              style: const TextStyle(
                                color: _muted,
                                fontSize: 14,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      for (var option = 0; option < 2; option++) ...[
                        _OptionCard(
                          text: question.options[option],
                          selected: selected == option,
                          onTap: () => ref
                              .read(personalityTestControllerProvider.notifier)
                              .answer(_index, option),
                        ),
                        if (option == 0) const SizedBox(height: 14),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 14, top: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: selected == null || _saving ? null : _next,
                    style: FilledButton.styleFrom(
                      backgroundColor: _orange,
                      disabledBackgroundColor: const Color(0xFFD2D2D5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            _index == 4 ? '결과 확인하기  ↗' : '다음 질문  ›',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.text,
    required this.selected,
    required this.onTap,
  });
  final String text;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected ? _orange : const Color(0xFFE1DAD8),
          width: selected ? 2 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? _orange : const Color(0xFF9A8179),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 16,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
