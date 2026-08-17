import 'package:flutter/material.dart' hide DayPeriod;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/features/detail/presentation/view_models/detail_view_model.dart';
import 'package:gallaemalae/presentation/widgets/adaptive_page.dart';

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

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.data});

  final DetailViewState data;

  @override
  Widget build(BuildContext context) {
    final festival = data.festival;
    final analysis = data.analysis;
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
        Text(
          festival.title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(festival.address),
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
