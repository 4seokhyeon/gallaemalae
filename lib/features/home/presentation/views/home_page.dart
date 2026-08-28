import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide DayPeriod;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/core/layout/app_layout.dart';
import 'package:gallaemalae/core/navigation/tab_reselection.dart';
import 'package:gallaemalae/core/router/app_routes.dart';
import 'package:gallaemalae/core/network/festival_request_status.dart';
import 'package:gallaemalae/features/home/presentation/view_models/home_view_model.dart';
import 'package:gallaemalae/features/personality/presentation/view_models/personality_view_model.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:go_router/go_router.dart';

const _brand = Color(0xFFC93A06);
const _brandDark = Color(0xFFB93403);
const _green = Color(0xFF098966);
const _ink = Color(0xFF28252B);
const _muted = Color(0xFF777079);
const _pageBackground = Color(0xFFF9F9FC);

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);
    final isRetryingFestivalList = ref.watch(festivalRequestStatusProvider);
    final personality = ref.watch(personalityProvider).value;
    final festivals = homeState.festivals?.items ?? const <FestivalSummary>[];
    final featuredFestival = festivals.isEmpty ? null : festivals.first;
    final analyses = <int, AsyncValue<FestivalAnalysis?>>{
      for (final festival in festivals)
        festival.id: ref.watch(homeFestivalAnalysisProvider(festival)),
    };

    final body = Stack(
      children: [
        const Positioned.fill(child: ColoredBox(color: _pageBackground)),
        ReselectableTabScrollView(
          tabIndex: 0,
          builder: (controller) => CustomScrollView(
            controller: controller,
            slivers: [
              SliverToBoxAdapter(child: _HomeHeader()),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  AppLayout.horizontalPadding(context),
                  30,
                  AppLayout.horizontalPadding(context),
                  AppLayout.navigationOverlayInset(context) + 34,
                ),
                sliver: SliverList.list(
                  children: [
                    const _SectionTitle(icon: '✦', title: '오늘의 AI 맞춤 추천'),
                    if (isRetryingFestivalList) ...[
                      const SizedBox(height: 14),
                      const _FestivalRetryNotice(),
                    ],
                    if (homeState.recommendationNotice != null) ...[
                      const SizedBox(height: 14),
                      _RecommendationNotice(
                        message: homeState.recommendationNotice!,
                      ),
                    ],
                    if (featuredFestival != null) ...[
                      const SizedBox(height: 16),
                      _HeroRecommendationCard(
                        personalityLabel: personality?.shortTitle ?? '성향 분석 중',
                        festival: featuredFestival,
                        recommendationReason: homeState.recommendationReason,
                        analysis: analyses[featuredFestival.id]!,
                      ),
                      if (festivals.length > 1) ...[
                        const SizedBox(height: 28),
                        const _TopFestivalsHeader(),
                        const SizedBox(height: 14),
                      ],
                    ],
                    if (homeState.isRefreshing && homeState.festivals == null)
                      const Center(child: CircularProgressIndicator())
                    else if (homeState.errorMessage != null)
                      _ApiErrorCard(
                        message: homeState.errorMessage!,
                        onRetry: () =>
                            ref.read(homeViewModelProvider.notifier).refresh(),
                      )
                    else if (festivals.isEmpty)
                      _HomeEmptyCard(
                        onShowAll: () => context.push(AppRoutes.festivals),
                        onRetest: () {
                          ref
                              .read(personalityTestControllerProvider.notifier)
                              .reset();
                          context.go(AppRoutes.personalityTest);
                        },
                      )
                    else
                      for (final festival in festivals.skip(1)) ...[
                        _ApiFestivalCard(
                          festival: festival,
                          analysis: analyses[festival.id]!,
                        ),
                        const SizedBox(height: 18),
                      ],
                    if (featuredFestival != null) ...[
                      const SizedBox(height: 6),
                      _PredictionGuideCard(
                        festival: featuredFestival,
                        analysis: analyses[featuredFestival.id]!,
                      ),
                      const SizedBox(height: 18),
                      _HomeTimeAnalysisCard(
                        analysis: analyses[featuredFestival.id]!,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: AppLayout.horizontalPadding(context),
          bottom: AppLayout.navigationOverlayInset(context) + 18,
          child: const _SearchButton(),
        ),
      ],
    );

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageScaffold(child: SafeArea(bottom: false, child: body));
    }
    return Scaffold(body: SafeArea(bottom: false, child: body));
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEAE7E7))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu_rounded, color: _brand, size: 25),
          const Text(
            '갈래말래',
            style: TextStyle(
              color: _brand,
              fontSize: 21,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.8,
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(CupertinoIcons.bell, color: _brand, size: 23),
              Positioned(
                right: 1,
                top: 0,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: _brand,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});

  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          icon,
          style: const TextStyle(
            color: _brand,
            fontSize: 26,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _HeroRecommendationCard extends StatelessWidget {
  const _HeroRecommendationCard({
    required this.personalityLabel,
    required this.festival,
    required this.recommendationReason,
    required this.analysis,
  });

  final String personalityLabel;
  final FestivalSummary festival;
  final String recommendationReason;
  final AsyncValue<FestivalAnalysis?> analysis;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFF1B9A5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 18,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: AppLayout.isCompactWidth(context) ? 1.45 : 1.72,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  _FestivalImage(
                    url: festival.primaryImageUrl,
                    fallbackColor: const Color(0xFF153D57),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xCC160900)],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 18,
                    right: 18,
                    bottom: 19,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _brand,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text(
                            '취향 추천',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          festival.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
              child: Column(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final preference = _InsightChip(
                        icon: Icons.person_search_outlined,
                        label: '사용자 성향',
                        value: personalityLabel,
                        iconColor: _brand,
                      );
                      final category = _InsightChip(
                        icon: Icons.insights_rounded,
                        label: '혼잡도 예측',
                        value: _analysisShortLabel(analysis),
                        iconColor: const Color(0xFF0958FF),
                      );
                      if (constraints.maxWidth < 360) {
                        return Column(
                          children: [
                            preference,
                            const SizedBox(height: 10),
                            category,
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(child: preference),
                          const SizedBox(width: 12),
                          Expanded(child: category),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1EC),
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: const Color(0xFFFFC8B5)),
                    ),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          color: Color(0xFF87341E),
                          height: 1.65,
                          fontSize: 14,
                        ),
                        children: [
                          const TextSpan(
                            text: '추천 이유: ',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          TextSpan(text: recommendationReason),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 17),
                  _PrimaryButton(
                    label: '실시간 혼잡도 리포트 보기',
                    onTap: () =>
                        context.push(AppRoutes.detail(festival.id.toString())),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightChip extends StatelessWidget {
  const _InsightChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 61,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: _ink, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _brandDark,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TopFestivalsHeader extends StatelessWidget {
  const _TopFestivalsHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '혼잡도 추천 TOP 3',
          style: TextStyle(
            color: _ink,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.festivals),
          child: const Text('전체보기 ›'),
        ),
      ],
    );
  }
}

class _ApiFestivalCard extends StatelessWidget {
  const _ApiFestivalCard({required this.festival, required this.analysis});

  final FestivalSummary festival;
  final AsyncValue<FestivalAnalysis?> analysis;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(18);
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius,
        side: const BorderSide(color: Color(0xFFF0B8A4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: () => context.push(AppRoutes.detail(festival.id.toString())),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 86,
                      height: 86,
                      child: _FestivalImage(
                        url: festival.primaryImageUrl,
                        fallbackColor: const Color(0xFFDCE8DE),
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
                          style: const TextStyle(
                            color: _ink,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          festival.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${_shortDate(festival.startDate)} – ${_shortDate(festival.endDate)}',
                          style: const TextStyle(color: _brand, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _analysisShortLabel(analysis),
                        style: TextStyle(
                          color: _analysisColor(analysis.valueOrNull),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Icon(Icons.chevron_right_rounded, color: _muted),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1E5E1)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: _PredictionMetrics(analysis: analysis),
            ),
          ],
        ),
      ),
    );
  }
}

class _PredictionMetrics extends StatelessWidget {
  const _PredictionMetrics({required this.analysis});
  final AsyncValue<FestivalAnalysis?> analysis;

  @override
  Widget build(BuildContext context) => analysis.when(
    loading: () => const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 15,
          height: 15,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: 8),
        Text('혼잡도 예측을 불러오는 중이에요', style: TextStyle(fontSize: 12)),
      ],
    ),
    error: (_, _) => const Text(
      '혼잡도 분석을 불러오지 못했어요',
      textAlign: TextAlign.center,
      style: TextStyle(color: _muted, fontSize: 12),
    ),
    data: (value) {
      if (value == null) {
        return const Text(
          '이 날짜의 혼잡도 예측이 아직 준비되지 않았어요',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 12),
        );
      }
      return Row(
        children: [
          Expanded(
            child: _Metric(value: '${value.overall.score}점', label: '혼잡 점수'),
          ),
          const _MetricDivider(),
          Expanded(
            child: _Metric(
              value: _periodLabel(value.recommendedPeriod),
              label: '추천 시간',
            ),
          ),
          const _MetricDivider(),
          Expanded(
            child: _Metric(
              value: '${(value.confidence * 100).round()}%',
              label: '예측 신뢰도',
            ),
          ),
        ],
      );
    },
  );
}

class _PredictionGuideCard extends StatelessWidget {
  const _PredictionGuideCard({required this.festival, required this.analysis});
  final FestivalSummary festival;
  final AsyncValue<FestivalAnalysis?> analysis;

  @override
  Widget build(BuildContext context) {
    final value = analysis.valueOrNull;
    final title = value == null
        ? 'AI 혼잡도 예측을 준비하고 있어요'
        : '${_periodLabel(value.recommendedPeriod)} 방문을 추천해요';
    final description = value == null
        ? '서버 분석이 준비되면 ${festival.title}의 추천 시간과 혼잡도를 알려드릴게요.'
        : '${festival.title}은(는) ${_periodLabel(value.busiestPeriod)}에 가장 붐빌 것으로 보여요. '
              '예측 신뢰도는 ${(value.confidence * 100).round()}%입니다.';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFBBC8FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.auto_graph_rounded, color: Color(0xFF0758FF)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(color: _muted, height: 1.5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTimeAnalysisCard extends StatelessWidget {
  const _HomeTimeAnalysisCard({required this.analysis});
  final AsyncValue<FestivalAnalysis?> analysis;

  @override
  Widget build(BuildContext context) {
    final value = analysis.valueOrNull;
    final slots = value?.timeSlots ?? const <TimeSlotPrediction>[];
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
      decoration: BoxDecoration(
        color: _brandDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value == null
                ? '시간대별 분석을 준비 중입니다'
                : '${_periodLabel(value.recommendedPeriod)}이 가장 쾌적합니다',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.35,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            value == null
                ? '분석 결과가 없어도 축제 목록과 상세 정보는 계속 확인할 수 있어요.'
                : '${_periodLabel(value.busiestPeriod)}은 가장 혼잡할 것으로 예측됩니다. '
                      '데이터 상태: ${_freshnessLabel(value.freshness)}',
            style: const TextStyle(
              color: Color(0xFFFFD8CA),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          if (slots.isNotEmpty)
            SizedBox(
              height: 84,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (final slot in slots)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 12 + slot.score * .42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: .28 + slot.score * .005,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              _periodLabel(slot.period),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            )
          else
            const SizedBox(
              height: 36,
              child: LinearProgressIndicator(
                backgroundColor: Color(0x55FFFFFF),
                color: Color(0xAAFFFFFF),
              ),
            ),
          const SizedBox(height: 18),
          FilledButton(
            onPressed: () => context.go(AppRoutes.analysis),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _brandDark,
            ),
            child: const Text('분석 리포트 전체보기'),
          ),
        ],
      ),
    );
  }
}

class _ApiErrorCard extends StatelessWidget {
  const _ApiErrorCard({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFF0B8A4)),
    ),
    child: Column(
      children: [
        const Icon(Icons.cloud_off_rounded, color: _brand, size: 34),
        const SizedBox(height: 8),
        const Text(
          '첫 축제 정보를 불러오지 못했어요',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 10),
        TextButton(onPressed: onRetry, child: const Text('다시 시도')),
      ],
    ),
  );
}

class _FestivalRetryNotice extends StatelessWidget {
  const _FestivalRetryNotice();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF4E5),
      borderRadius: BorderRadius.circular(14),
    ),
    child: const Row(
      children: [
        SizedBox(
          width: 18,
          height: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        SizedBox(width: 10),
        Expanded(child: Text('서버에서 축제 정보를 불러오는 중이에요')),
      ],
    ),
  );
}

class _RecommendationNotice extends StatelessWidget {
  const _RecommendationNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFFF4E5),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: const Color(0xFFFFD49A)),
    ),
    child: Row(
      children: [
        const Icon(Icons.info_outline_rounded, color: Color(0xFF9A5B00)),
        const SizedBox(width: 10),
        Expanded(child: Text(message, style: const TextStyle(fontSize: 13))),
      ],
    ),
  );
}

class _HomeEmptyCard extends StatelessWidget {
  const _HomeEmptyCard({required this.onShowAll, required this.onRetest});

  final VoidCallback onShowAll;
  final VoidCallback onRetest;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 16),
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: const Color(0xFFE5E2E4)),
    ),
    child: Column(
      children: [
        const Icon(Icons.search_off_rounded, color: _muted, size: 38),
        const SizedBox(height: 12),
        const Text(
          '조건에 맞는 축제를 찾지 못했어요',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 7),
        const Text(
          '현재 등록된 일정에서는 추천할 축제가 없습니다.\n검색 범위를 넓히거나 성향을 다시 설정해 보세요.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 13, height: 1.5),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: onShowAll,
            child: const Text('전체 축제 보기'),
          ),
        ),
        TextButton(onPressed: onRetest, child: const Text('성향 다시 설정')),
      ],
    ),
  );
}

String _shortDate(DateTime date) => '${date.month}.${date.day}';

String _analysisShortLabel(AsyncValue<FestivalAnalysis?> analysis) {
  if (analysis.isLoading) return '분석 중';
  final value = analysis.valueOrNull;
  if (value == null) return '예측 준비 중';
  return '${value.overall.score} · ${_crowdLabel(value.overall.level)}';
}

Color _analysisColor(FestivalAnalysis? analysis) {
  if (analysis == null) return _muted;
  return switch (analysis.overall.level) {
    CrowdLevel.low => const Color(0xFF098966),
    CrowdLevel.medium => const Color(0xFFE37418),
    CrowdLevel.high => const Color(0xFFD94A32),
    CrowdLevel.veryHigh => const Color(0xFFB91C1C),
  };
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

String _freshnessLabel(DataFreshness freshness) => switch (freshness) {
  DataFreshness.fresh => '최신 예측',
  DataFreshness.stale => '저장된 예측',
  DataFreshness.unavailable => '준비 중',
};

// Kept for the richer recommendation response planned by the API contract.
// ignore: unused_element
class _FestivalCard extends StatelessWidget {
  const _FestivalCard({
    required this.placeId,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.subtitle,
    required this.score,
    required this.weather,
    required this.wait,
    required this.progress,
    required this.imageUrl,
  });

  final String placeId;
  final String title;
  final String status;
  final Color statusColor;
  final String subtitle;
  final int score;
  final String weather;
  final String wait;
  final double progress;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.detail(placeId)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF0B8A4)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: 80,
                      height: 78,
                      child: _FestivalImage(
                        url: imageUrl,
                        fallbackColor: const Color(0xFFDCE8DE),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: _ink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Text(
                          subtitle,
                          style: const TextStyle(color: _muted, fontSize: 12),
                        ),
                        const SizedBox(height: 11),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 4,
                            backgroundColor: const Color(0xFFE7E7EB),
                            valueColor: const AlwaysStoppedAnimation(_green),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1E5E1)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.info_outline, color: _brand, size: 15),
                      SizedBox(width: 5),
                      Text(
                        '추천 사유',
                        style: TextStyle(color: _brand, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      Expanded(
                        child: _Metric(value: '$score%', label: '성향 일치'),
                      ),
                      const _MetricDivider(),
                      Expanded(
                        child: _Metric(value: weather, label: '날씨 적합도'),
                      ),
                      const _MetricDivider(),
                      Expanded(
                        child: _Metric(value: wait, label: '여유 지속'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: _ink,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(label, style: const TextStyle(color: _muted, fontSize: 11)),
      ],
    );
  }
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 34, color: const Color(0xFFECE5E3));
  }
}

// Reserved until weather and indoor-place APIs are available.
// ignore: unused_element
class _RainyDayCard extends StatelessWidget {
  const _RainyDayCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8ECFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFB8C6FF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(CupertinoIcons.cloud_rain, color: Color(0xFF0758FF)),
              SizedBox(width: 12),
              Text(
                '비 오는 오후, 실내 축제 추천',
                style: TextStyle(color: _ink, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _IndoorPlaceTile(
            icon: Icons.museum_outlined,
            title: '국립중앙박물관 기획전',
            subtitle: '실내 쾌적도 95% · 혼잡도 낮음',
            onTap: () => context.push(AppRoutes.detail('national-museum')),
          ),
          const SizedBox(height: 12),
          _IndoorPlaceTile(
            icon: Icons.theater_comedy_outlined,
            title: '대학로 소극장 페스티벌',
            subtitle: '매우 한적함 · 실내 활동 권장',
            onTap: () => context.push(AppRoutes.detail('daehakro-theater')),
          ),
        ],
      ),
    );
  }
}

class _IndoorPlaceTile extends StatelessWidget {
  const _IndoorPlaceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF0758FF)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: _ink, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: _muted, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _ink, size: 18),
          ],
        ),
      ),
    );
  }
}

// Reserved until a home-level time analysis API is available.
// ignore: unused_element
class _TimeAnalysisCard extends StatelessWidget {
  const _TimeAnalysisCard();

  @override
  Widget build(BuildContext context) {
    const heights = [16.0, 26.0, 40.0, 50.0, 25.0, 16.0, 9.0];
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
      decoration: BoxDecoration(
        color: _brandDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '오후 6시 이후가\n가장 쾌적합니다',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '주말 데이터 분석 결과, 일몰 직후 방문객이 30%\n감소하는 패턴을 보이고 있습니다.',
            style: TextStyle(
              color: Color(0xFFFFD8CA),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            height: 52,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < heights.length; index++)
                  Expanded(
                    child: Container(
                      height: heights[index],
                      margin: const EdgeInsets.only(right: 4),
                      decoration: BoxDecoration(
                        color: Color.lerp(
                          const Color(0xFFC85329),
                          const Color(0xFFE78967),
                          index / heights.length,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(3),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => context.go(AppRoutes.analysis),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                '분석 리포트 전체보기',
                style: TextStyle(color: _brand, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.festivals),
      child: Container(
        width: 58,
        height: 58,
        decoration: const BoxDecoration(
          color: _brandDark,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.search_rounded, color: Colors.white, size: 31),
      ),
    );
  }
}

class _FestivalImage extends StatelessWidget {
  const _FestivalImage({required this.url, required this.fallbackColor});

  final String url;
  final Color fallbackColor;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return ColoredBox(
          color: fallbackColor,
          child: const Center(
            child: Icon(Icons.festival_outlined, color: Colors.white, size: 38),
          ),
        );
      },
    );
  }
}
