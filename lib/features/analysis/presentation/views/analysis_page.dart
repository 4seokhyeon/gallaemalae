import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide DayPeriod;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/layout/app_layout.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/features/analysis/presentation/view_models/analysis_view_model.dart';

const _brand = Color(0xFFC93A06);
const _background = Color(0xFFF7F7FA);

class AnalysisPage extends ConsumerWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analysisViewModelProvider);
    final body = state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorView(
        message: error.toString(),
        onRetry: () => ref.invalidate(analysisViewModelProvider),
      ),
      data: (data) => data.when(
        selecting: (festivals) => _FestivalSelectionView(
          festivals: festivals,
          onSelected: (festival) => _selectDate(context, ref, festival),
        ),
        result: (festival, analysis, visitDate) => _AnalysisResultView(
          festival: festival,
          analysis: analysis,
          visitDate: visitDate,
          onChangeFestival: () => ref
              .read(analysisViewModelProvider.notifier)
              .chooseAnotherFestival(),
        ),
      ),
    );

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageScaffold(
        backgroundColor: _background,
        navigationBar: const CupertinoNavigationBar(
          middle: Text('혼잡도 분석'),
          backgroundColor: CupertinoColors.white,
        ),
        child: SafeArea(bottom: false, child: body),
      );
    }

    return Scaffold(
      backgroundColor: _background,
      appBar: AppBar(
        title: const Text('혼잡도 분석'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(child: body),
    );
  }

  Future<DateTime?> _pickDate(
    BuildContext context,
    FestivalSummary festival,
    DateTime initialDate,
  ) {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      return showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: festival.startDate,
        lastDate: festival.endDate,
        helpText: '${festival.title} 방문 예정일',
        cancelText: '취소',
        confirmText: '분석하기',
      );
    }

    var selectedDate = initialDate;
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
                  initialDateTime: initialDate,
                  minimumDate: festival.startDate,
                  maximumDate: festival.endDate,
                  onDateTimeChanged: (value) => selectedDate = value,
                ),
              ),
              CupertinoButton(
                onPressed: () => Navigator.of(popupContext).pop(selectedDate),
                child: const Text('분석하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    WidgetRef ref,
    FestivalSummary festival,
  ) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final initialDate = today.isBefore(festival.startDate)
        ? festival.startDate
        : today.isAfter(festival.endDate)
        ? festival.endDate
        : today;
    final date = await _pickDate(context, festival, initialDate);
    if (date == null) return;
    await ref
        .read(analysisViewModelProvider.notifier)
        .analyzeFestival(festival.id, date);
  }
}

class _FestivalSelectionView extends StatelessWidget {
  const _FestivalSelectionView({
    required this.festivals,
    required this.onSelected,
  });

  final List<FestivalSummary> festivals;
  final ValueChanged<FestivalSummary> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppLayout.horizontalPadding(context),
        30,
        AppLayout.horizontalPadding(context),
        AppLayout.navigationOverlayInset(context) + 30,
      ),
      children: [
        const Icon(Icons.query_stats_rounded, color: _brand, size: 54),
        const SizedBox(height: 18),
        Text(
          '어떤 축제가 궁금하세요?',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        const Text(
          '방문하려는 축제를 선택하면 날짜와 시간대별\n예상 혼잡도를 분석해 드릴게요.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF777079), height: 1.5),
        ),
        const SizedBox(height: 32),
        const Text(
          '분석 가능한 축제',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 14),
        if (festivals.isEmpty)
          const _EmptyFestivalsCard()
        else
          for (final festival in festivals) ...[
            _FestivalCard(
              festival: festival,
              onTap: () => onSelected(festival),
            ),
            const SizedBox(height: 12),
          ],
      ],
    );
  }
}

class _FestivalCard extends StatelessWidget {
  const _FestivalCard({required this.festival, required this.onTap});

  final FestivalSummary festival;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 76,
                height: 76,
                child: festival.primaryImageUrl.isEmpty
                    ? const ColoredBox(
                        color: Color(0xFFFFE5DD),
                        child: Icon(Icons.festival_rounded, color: _brand),
                      )
                    : Image.network(
                        festival.primaryImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => const ColoredBox(
                          color: Color(0xFFFFE5DD),
                          child: Icon(Icons.festival_rounded, color: _brand),
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    festival.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    festival.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF777079)),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${_date(festival.startDate)} – ${_date(festival.endDate)}',
                    style: const TextStyle(color: _brand, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    ),
  );
}

class _AnalysisResultView extends StatelessWidget {
  const _AnalysisResultView({
    required this.festival,
    required this.analysis,
    required this.visitDate,
    required this.onChangeFestival,
  });

  final FestivalDetail festival;
  final FestivalAnalysis analysis;
  final DateTime visitDate;
  final VoidCallback onChangeFestival;

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.fromLTRB(
      AppLayout.horizontalPadding(context),
      24,
      AppLayout.horizontalPadding(context),
      AppLayout.navigationOverlayInset(context) + 30,
    ),
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  festival.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text('${festival.address} · ${_date(visitDate)}'),
              ],
            ),
          ),
          TextButton(onPressed: onChangeFestival, child: const Text('축제 변경')),
        ],
      ),
      const SizedBox(height: 22),
      _FreshnessBanner(freshness: analysis.freshness),
      const SizedBox(height: 12),
      Card(
        color: const Color(0xFFFFF1EC),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('예상 혼잡 점수'),
              const SizedBox(height: 8),
              if (analysis.freshness == DataFreshness.unavailable) ...[
                const SizedBox(height: 8),
                const Icon(Icons.cloud_off_rounded, color: Color(0xFF777079)),
                const SizedBox(height: 8),
                const Text(
                  '현재 예측에 필요한 데이터가 부족합니다.',
                  textAlign: TextAlign.center,
                ),
              ] else ...[
                Text(
                  '${analysis.overall.score}',
                  style: const TextStyle(
                    color: _brand,
                    fontSize: 52,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(_crowdLabel(analysis.overall.level)),
                const SizedBox(height: 10),
                Text('예측 신뢰도 ${(analysis.confidence * 100).round()}%'),
              ],
            ],
          ),
        ),
      ),
      const SizedBox(height: 24),
      const Text(
        '시간대별 혼잡 예측',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 10),
      for (final slot in analysis.timeSlots)
        Card(
          child: ListTile(
            title: Text(_periodLabel(slot.period)),
            subtitle: Text('${slot.startTime} – ${slot.endTime}'),
            trailing: Text(
              '${slot.score}점\n${_crowdLabel(slot.level)}',
              textAlign: TextAlign.end,
            ),
          ),
        ),
      const SizedBox(height: 18),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '추천 방문 시간: ${_periodLabel(analysis.recommendedPeriod)}',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              Text('가장 혼잡한 시간: ${_periodLabel(analysis.busiestPeriod)}'),
              const SizedBox(height: 10),
              ...analysis.factors.map((factor) => Text('• $factor')),
            ],
          ),
        ),
      ),
      const SizedBox(height: 14),
      Text(
        '예측 기준 시각: ${_dateTime(analysis.basedAt)}\n'
        '데이터 업데이트: ${_dateTime(analysis.dataUpdatedAt)}',
        style: const TextStyle(
          color: Color(0xFF777079),
          fontSize: 12,
          height: 1.6,
        ),
      ),
    ],
  );
}

class _FreshnessBanner extends StatelessWidget {
  const _FreshnessBanner({required this.freshness});

  final DataFreshness freshness;

  @override
  Widget build(BuildContext context) {
    final (icon, title, message, color) = switch (freshness) {
      DataFreshness.fresh => (
        Icons.check_circle_outline_rounded,
        '최신 데이터',
        '최근 수집된 데이터를 기준으로 분석했어요.',
        const Color(0xFF098966),
      ),
      DataFreshness.stale => (
        Icons.schedule_rounded,
        '업데이트 지연',
        '최근 수집된 데이터로 예측해 실제 상황과 다를 수 있어요.',
        const Color(0xFFB26A00),
      ),
      DataFreshness.unavailable => (
        Icons.info_outline_rounded,
        '데이터 부족',
        '다른 방문 날짜를 선택하거나 잠시 후 다시 확인해 주세요.',
        const Color(0xFF777079),
      ),
    };
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(message, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('다시 시도')),
        ],
      ),
    ),
  );
}

class _EmptyFestivalsCard extends StatelessWidget {
  const _EmptyFestivalsCard();

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: Text('현재 분석할 수 있는 축제가 없습니다.', textAlign: TextAlign.center),
    ),
  );
}

String _date(DateTime value) =>
    '${value.year}.${value.month.toString().padLeft(2, '0')}.'
    '${value.day.toString().padLeft(2, '0')}';

String _dateTime(DateTime value) {
  final local = value.toLocal();
  return '${_date(local)} '
      '${local.hour.toString().padLeft(2, '0')}:'
      '${local.minute.toString().padLeft(2, '0')}';
}

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
