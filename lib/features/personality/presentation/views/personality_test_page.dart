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
  const _Question(
    this.title,
    this.subtitle,
    this.options,
    this.icon, {
    this.multi = false,
  });
  final String title;
  final String subtitle;
  final List<String> options;
  final IconData icon;
  final bool multi;
}

const _questions = [
  _Question(
    '평소 축제·여행에서 끌리는 걸 골라주세요',
    '가장 마음에 드는 콘텐츠를 1~2개 선택해 주세요.',
    ['자연 풍경·산책', '먹거리·특산물', '공연·불꽃놀이·이벤트', '전통·역사·유적', '체험·전시·문화행사', '딱히 상관없음'],
    Icons.category_rounded,
    multi: true,
  ),
  _Question('축제에 갔을 때 어느 쪽이 더 좋으세요?', '선호하는 현장 분위기를 선택해 주세요.', [
    '사람 많고 활기찬 분위기',
    '적당히 붐비는 정도',
    '한산하게 여유 있게',
  ], Icons.groups_rounded),
  _Question('주로 언제 나들이하는 걸 좋아하세요?', '가장 편안한 방문 시간대를 선택해 주세요.', [
    '아침 일찍',
    '낮부터 오후',
    '해 질 무렵부터 저녁',
  ], Icons.schedule_rounded),
  _Question('축제, 어디까지 가볼 생각 있으세요?', '추천받고 싶은 활동 반경을 선택해 주세요.', [
    '집 근처 같은 시·군',
    '조금 멀어도 괜찮은 인접 지역',
    '전국 어디든',
  ], Icons.map_rounded),
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
                  padding: const EdgeInsets.fromLTRB(0, 28, 0, 96),
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
                            '${(((_index + 1) / _questions.length) * 100).round()}%',
                            style: const TextStyle(color: _muted, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: LinearProgressIndicator(
                          value: (_index + 1) / _questions.length,
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
                      for (
                        var option = 0;
                        option < question.options.length;
                        option++
                      ) ...[
                        _OptionCard(
                          text: question.options[option],
                          selected: question.multi
                              ? selected != null &&
                                    (selected & (1 << option)) != 0
                              : selected == option,
                          onTap: () {
                            final controller = ref.read(
                              personalityTestControllerProvider.notifier,
                            );
                            if (question.multi) {
                              controller.toggleCategory(option);
                            } else {
                              controller.answer(_index, option);
                            }
                          },
                        ),
                        if (option < question.options.length - 1)
                          const SizedBox(height: 10),
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
                            _index == _questions.length - 1
                                ? '결과 확인하기  ↗'
                                : '다음 질문  ›',
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
