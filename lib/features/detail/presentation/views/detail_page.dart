import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide DayPeriod;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/features/detail/presentation/view_models/detail_view_model.dart';
import 'package:gallaemalae/features/favorites/presentation/view_models/favorites_view_model.dart';
import 'package:gallaemalae/features/visits/presentation/view_models/visit_plans_view_model.dart';
import 'package:gallaemalae/presentation/widgets/adaptive_page.dart';
import 'package:go_router/go_router.dart';

class DetailPage extends ConsumerWidget {
  const DetailPage({required this.placeId, super.key});

  final String placeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivalId = int.tryParse(placeId);
    if (festivalId == null) {
      return const AdaptivePage(
        title: '상세 예측',
        child: Center(child: Text('올바르지 않은 축제 번호입니다.')),
      );
    }
    final state = ref.watch(detailViewModelProvider(festivalId));
    return AdaptivePage(
      title: '상세 예측',
      child: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(error.toString(), textAlign: TextAlign.center),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () =>
                      ref.invalidate(detailViewModelProvider(festivalId)),
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
        data: (data) => _DetailContent(data: data),
      ),
    );
  }
}

class _DetailContent extends ConsumerWidget {
  const _DetailContent({required this.data});

  final DetailViewState data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festival = data.festival;
    final analysis = data.analysis;
    final isFavorite = ref.watch(isFavoriteProvider(festival.id));
    final plans = ref.watch(visitPlansProvider).valueOrNull ?? const [];
    final scheduled = plans.where((plan) => plan.placeId == '${festival.id}');
    final available = analysis.freshness != DataFreshness.unavailable;
    return ListView(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 24),
      children: [
        Wrap(
          spacing: 6,
          children: [
            _Badge(
              label: _categoryLabel(festival.category),
              color: const Color(0xFF536DFE),
            ),
            _Badge(
              label: _freshnessLabel(analysis.freshness),
              color: const Color(0xFF009688),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                festival.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            IconButton(
              tooltip: isFavorite ? '관심 축제에서 삭제' : '관심 축제에 저장',
              onPressed: () async {
                try {
                  await ref
                      .read(favoritesControllerProvider.notifier)
                      .toggle(festival);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavorite ? '관심 축제에서 삭제했어요.' : '관심 축제에 저장했어요.',
                      ),
                    ),
                  );
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('관심 축제를 저장하지 못했어요.')),
                  );
                }
              },
              icon: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(festival.address),
        const SizedBox(height: 4),
        Text(
          '${_date(festival.startDate)} - ${_date(festival.endDate)}',
          style: const TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 18),
        if (!available)
          _UnavailableCard(
            onRetry: () => ref.invalidate(detailViewModelProvider(festival.id)),
          )
        else ...[
          _DecisionCard(
            score: analysis.overall.score,
            recommendedPeriod: analysis.recommendedPeriod,
            scheduledLabel: scheduled.isEmpty
                ? '지금 방문 계획 세우기'
                : '${_date(scheduled.first.visitedAt)} 일정 변경하기',
            onPressed: () => _scheduleVisit(context, ref),
          ),
          const SizedBox(height: 12),
          _CrowdScoreCard(prediction: analysis.overall),
          const SizedBox(height: 18),
          _SectionTitle(
            title: '시간대별 AI 혼잡 예측',
            trailing: '예측일 ${_date(analysis.predictedFor)}',
          ),
          const SizedBox(height: 8),
          _TimeSlotChart(
            slots: analysis.timeSlots,
            recommended: analysis.recommendedPeriod,
            busiest: analysis.busiestPeriod,
          ),
          const SizedBox(height: 12),
          _AnalysisDetailCard(analysis: analysis),
          const SizedBox(height: 12),
          _FestivalInfoCard(festival: festival),
        ],
      ],
    );
  }

  Future<void> _scheduleVisit(BuildContext context, WidgetRef ref) async {
    final festival = data.festival;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = DateTime(
      festival.startDate.year,
      festival.startDate.month,
      festival.startDate.day,
    );
    final end = DateTime(
      festival.endDate.year,
      festival.endDate.month,
      festival.endDate.day,
    );
    final firstDate = today.isAfter(start) ? today : start;
    if (firstDate.isAfter(end)) {
      await showAdaptiveDialog<void>(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: const Text('종료된 축제예요'),
          content: const Text('축제 기간이 지나 방문 예정일을 저장할 수 없어요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
      return;
    }

    final selected = await _pickVisitDate(context, firstDate, end);
    if (selected == null || !context.mounted) return;
    await ref
        .read(visitPlansControllerProvider.notifier)
        .save(
          festival: festival,
          visitDate: selected,
          crowdScore: data.analysis.overall.score,
        );
    if (!context.mounted) return;
    context.go(AppRoutes.analysis);
  }

  Future<DateTime?> _pickVisitDate(
    BuildContext context,
    DateTime firstDate,
    DateTime lastDate,
  ) {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return showDatePicker(
        context: context,
        initialDate: firstDate,
        firstDate: firstDate,
        lastDate: lastDate,
        helpText: '${data.festival.title} 방문 예정일',
        cancelText: '취소',
        confirmText: '저장하고 분석하기',
      );
    }

    var selectedDate = firstDate;
    return showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (popupContext) => Container(
        height: 330,
        color: CupertinoColors.systemBackground.resolveFrom(popupContext),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: firstDate,
                  minimumDate: firstDate,
                  maximumDate: lastDate.add(const Duration(hours: 23)),
                  onDateTimeChanged: (value) => selectedDate = value,
                ),
              ),
              CupertinoButton(
                onPressed: () => Navigator.pop(popupContext, selectedDate),
                child: const Text('저장하고 분석하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _date(DateTime value) =>
    '${value.year}.${value.month.toString().padLeft(2, '0')}.'
    '${value.day.toString().padLeft(2, '0')}';

String _crowdLabel(CrowdLevel level) => switch (level) {
  CrowdLevel.low => '여유',
  CrowdLevel.medium => '보통',
  CrowdLevel.high => '혼잡',
  CrowdLevel.veryHigh => '매우 혼잡',
};

String _periodLabel(DayPeriod period) => switch (period) {
  DayPeriod.morning => '오전',
  DayPeriod.afternoon => '오후',
  DayPeriod.evening => '저녁',
};

String _categoryLabel(FestivalCategory category) => switch (category) {
  FestivalCategory.culture => '문화 · 체험',
  FestivalCategory.nature => '자연 · 산책',
  FestivalCategory.food => '먹거리',
  FestivalCategory.performance => '공연 · 이벤트',
  FestivalCategory.tradition => '전통 · 역사',
  FestivalCategory.other => '기타 축제',
};

String _freshnessLabel(DataFreshness freshness) => switch (freshness) {
  DataFreshness.fresh => 'LIVE Data',
  DataFreshness.stale => '최근 예측',
  DataFreshness.unavailable => '예측 준비 중',
};

Color _scoreColor(int score) {
  if (score < 35) return const Color(0xFF28B78D);
  if (score < 65) return const Color(0xFFF4A62A);
  return const Color(0xFFFF6338);
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: color.withValues(alpha: .12),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    elevation: 0,
    color: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(padding: const EdgeInsets.all(18), child: child),
  );
}

class _DecisionCard extends StatelessWidget {
  const _DecisionCard({
    required this.score,
    required this.recommendedPeriod,
    required this.scheduledLabel,
    required this.onPressed,
  });
  final int score;
  final DayPeriod recommendedPeriod;
  final String scheduledLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final go = score < 65;
    final color = go ? const Color(0xFFB33A08) : const Color(0xFFD9382B);
    return _ReportCard(
      child: Column(
        children: [
          const Text(
            '오늘의 갈래? 말래?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Container(
            width: 94,
            height: 94,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 5),
            ),
            child: Text(
              go ? '갈래!' : '말래!',
              style: TextStyle(
                color: color,
                fontSize: 27,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            go
                ? '현재 혼잡도는 ${_crowdLabel(score < 35 ? CrowdLevel.low : CrowdLevel.medium)} 수준이에요. ${_periodLabel(recommendedPeriod)} 방문을 추천해요.'
                : '현재 혼잡도가 높은 편이에요. 가능하면 ${_periodLabel(recommendedPeriod)}으로 시간을 바꿔보세요.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: onPressed,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFFF6338),
              ),
              child: Text(scheduledLabel),
            ),
          ),
        ],
      ),
    );
  }
}

class _CrowdScoreCard extends StatelessWidget {
  const _CrowdScoreCard({required this.prediction});
  final CrowdPrediction prediction;
  @override
  Widget build(BuildContext context) => _ReportCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '실시간 혼잡 점수',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: _scoreColor(prediction.score),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                '${prediction.score}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (context, constraints) => Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF2ED39A),
                      Color(0xFFF2D64B),
                      Color(0xFFFF6338),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: (constraints.maxWidth - 18) * prediction.score / 100,
                top: -5,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _scoreColor(prediction.score),
                      width: 3,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('쾌적함', style: TextStyle(fontSize: 11)),
            Text('매우 붐빔', style: TextStyle(fontSize: 11)),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '${_crowdLabel(prediction.level)} 단계로 예측되고 있어요.',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.trailing});
  final String title;
  final String trailing;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      Text(
        trailing,
        style: const TextStyle(fontSize: 11, color: Colors.black54),
      ),
    ],
  );
}

class _TimeSlotChart extends StatelessWidget {
  const _TimeSlotChart({
    required this.slots,
    required this.recommended,
    required this.busiest,
  });
  final List<TimeSlotPrediction> slots;
  final DayPeriod recommended;
  final DayPeriod busiest;
  @override
  Widget build(BuildContext context) => _ReportCard(
    child: slots.isEmpty
        ? const Text('시간대별 예측 데이터가 아직 없어요.')
        : SizedBox(
            // 최대 점수(100)의 막대와 상·하단 라벨이 함께 들어갈 공간입니다.
            // 190px에서는 99~100점 응답일 때 Column이 아래로 넘쳤습니다.
            height: 230,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: slots.map((slot) {
                final selected = slot.period == busiest;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (slot.period == recommended)
                          const Text(
                            '추천',
                            style: TextStyle(
                              color: Color(0xFF009688),
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        else
                          const SizedBox(height: 14),
                        Text(
                          '${slot.score}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 35 + slot.score.toDouble(),
                          decoration: BoxDecoration(
                            color: _scoreColor(
                              slot.score,
                            ).withValues(alpha: .72),
                            border: selected
                                ? Border.all(
                                    color: const Color(0xFFB33A08),
                                    width: 3,
                                  )
                                : null,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(7),
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          _periodLabel(slot.period),
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${slot.startTime}~${slot.endTime}',
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
  );
}

class _AnalysisDetailCard extends StatelessWidget {
  const _AnalysisDetailCard({required this.analysis});
  final FestivalAnalysis analysis;
  @override
  Widget build(BuildContext context) => _ReportCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.psychology_alt_outlined, color: Color(0xFFFF6338)),
            SizedBox(width: 8),
            Text(
              'AI 예측 분석 상세',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          '예측 신뢰도 ${(analysis.confidence * 100).round()}% · ${_freshnessLabel(analysis.freshness)}',
        ),
        const SizedBox(height: 8),
        Text('가장 붐비는 시간: ${_periodLabel(analysis.busiestPeriod)}'),
        Text('추천 방문 시간: ${_periodLabel(analysis.recommendedPeriod)}'),
        if (analysis.factors.isNotEmpty) ...[
          const Divider(height: 24),
          const Text(
            '분석에 반영된 데이터',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          ...analysis.factors.map(
            (factor) => Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text('• $factor'),
            ),
          ),
        ],
        const SizedBox(height: 8),
        Text(
          '데이터 갱신 ${_dateTime(analysis.dataUpdatedAt)}',
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    ),
  );
}

class _FestivalInfoCard extends StatelessWidget {
  const _FestivalInfoCard({required this.festival});
  final FestivalDetail festival;
  @override
  Widget build(BuildContext context) => _ReportCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '축제 위치 및 정보',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.place_outlined, color: Color(0xFFFF6338)),
            const SizedBox(width: 8),
            Expanded(child: Text(festival.address)),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          '주차·교통 정보는 현재 API에서 제공되지 않아요.',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    ),
  );
}

class _UnavailableCard extends StatelessWidget {
  const _UnavailableCard({required this.onRetry});
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => _ReportCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.info_outline_rounded),
            SizedBox(width: 8),
            Text('혼잡도 예측 준비 중', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        const SizedBox(height: 10),
        const Text('이 날짜의 분석 데이터가 아직 없어요. 다른 날짜를 선택하거나 잠시 후 다시 확인해 주세요.'),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('다시 확인'),
        ),
      ],
    ),
  );
}

String _dateTime(DateTime value) =>
    '${_date(value.toLocal())} ${value.toLocal().hour.toString().padLeft(2, '0')}:${value.toLocal().minute.toString().padLeft(2, '0')}';
