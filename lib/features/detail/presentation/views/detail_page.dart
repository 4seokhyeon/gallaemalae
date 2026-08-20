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
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (festival.primaryImageUrl.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                festival.primaryImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const ColoredBox(
                  color: Color(0xFFE8E8EC),
                  child: Icon(Icons.festival_rounded, size: 56),
                ),
              ),
            ),
          ),
        const SizedBox(height: 18),
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
            IconButton.filledTonal(
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
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () => _scheduleVisit(context, ref),
          icon: const Icon(Icons.calendar_month_rounded),
          label: Text(
            scheduled.isEmpty
                ? '방문 예정일 저장하기'
                : '${_date(scheduled.first.visitedAt)} 방문 예정 · 날짜 변경',
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '예상 혼잡도',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Text(
                  '${analysis.overall.score}점 · ${_crowdLabel(analysis.overall.level)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text('추천 시간대: ${_periodLabel(analysis.recommendedPeriod)}'),
                Text('예측 신뢰도: ${(analysis.confidence * 100).round()}%'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...analysis.timeSlots.map(
          (slot) => ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_periodLabel(slot.period)),
            subtitle: Text('${slot.startTime} – ${slot.endTime}'),
            trailing: Text('${slot.score}점 · ${_crowdLabel(slot.level)}'),
          ),
        ),
        if (analysis.factors.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text('분석 요인', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...analysis.factors.map((factor) => Text('• $factor')),
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
              SizedBox(
                height: 260,
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
