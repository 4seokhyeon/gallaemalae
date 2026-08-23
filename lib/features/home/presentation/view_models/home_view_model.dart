import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gallaemalae/features/personality/presentation/view_models/personality_view_model.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/domain/entities/festival_personality.dart';
import 'package:gallaemalae/domain/entities/favorite_place.dart';
import 'package:gallaemalae/features/favorites/presentation/view_models/favorites_view_model.dart';

part 'home_view_model.freezed.dart';

@freezed
abstract class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    @Default('데이터를 분석하고 있어요') String summary,
    @Default(false) bool isRefreshing,
    FestivalPage? festivals,
    String? errorMessage,
    String? recommendationNotice,
    @Default('30일 이내 방문할 수 있는 축제예요.') String recommendationReason,
  }) = _HomeViewState;
}

class HomeViewModel extends AutoDisposeNotifier<HomeViewState> {
  Future<void>? _activeRefresh;

  @override
  HomeViewState build() {
    ref.watch(personalityProvider);
    ref.watch(favoritePlacesProvider);
    Future<void>.microtask(refresh);
    return const HomeViewState();
  }

  /// 추천 API Repository 호출 시 body/query에 그대로 전달할 개인화 파라미터입니다.
  Map<String, Object?> get recommendationParameters {
    final personality = ref.read(personalityProvider).value;
    return {
      'personalityType': personality?.apiCode,
      'personalityAnswers': personality?.answers,
    };
  }

  Future<void> refresh() {
    final active = _activeRefresh;
    if (active != null) return active;
    final future = _performRefresh();
    _activeRefresh = future;
    return future.whenComplete(() {
      if (identical(_activeRefresh, future)) _activeRefresh = null;
    });
  }

  Future<void> _performRefresh() async {
    state = state.copyWith(
      isRefreshing: true,
      errorMessage: null,
      recommendationNotice: null,
    );
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final personality = ref.read(personalityProvider).value;
      final preferredCategorySet = personality == null
          ? const <FestivalCategory>{}
          : personality.hasRecommendationProfile
          ? personality.apiCategories
          : preferredCategories(personality.type);
      final favorites =
          ref.read(favoritePlacesProvider).valueOrNull ??
          const <FavoritePlace>[];
      final favoriteCategories = favoriteCategoryCounts(favorites);
      final repository = ref.read(festivalRepositoryProvider);
      final requestedCategories = personality?.hasRecommendationProfile ?? false
          ? personality!.apiCategories
          : const <FestivalCategory>{};
      var windowDays = 30;
      String? recommendationNotice;
      var response = await repository.search(
        from: today,
        to: today.add(const Duration(days: 30)),
        categories: requestedCategories,
        size: 20,
      );
      if (response.items.isEmpty && requestedCategories.isNotEmpty) {
        windowDays = 90;
        recommendationNotice = '선호한 유형의 축제가 없어 기간을 90일까지 넓혔어요.';
        response = await repository.search(
          from: today,
          to: today.add(const Duration(days: 90)),
          categories: requestedCategories,
          size: 20,
        );
      }
      if (response.items.isEmpty && requestedCategories.isNotEmpty) {
        windowDays = 30;
        recommendationNotice = '선호 조건에 맞는 축제가 없어 다른 유형까지 함께 추천해요.';
        response = await repository.search(
          from: today,
          to: today.add(const Duration(days: 30)),
          size: 20,
        );
      }
      if (response.items.isEmpty && windowDays < 90) {
        windowDays = 90;
        recommendationNotice = '가까운 일정의 축제가 없어 전체 유형을 90일까지 넓혀 찾았어요.';
        response = await repository.search(
          from: today,
          to: today.add(const Duration(days: 90)),
          size: 20,
        );
      }
      final ranked = rankHomeRecommendations(
        response.items,
        preferredCategories: preferredCategorySet,
        favoriteCategoryCounts: favoriteCategories,
      ).take(3).toList();
      final festivals = response.copyWith(items: ranked);
      final featuredFestival = festivals.items.firstOrNull;
      final hasFavoritePreference = favoriteCategories.isNotEmpty;
      state = state.copyWith(
        summary: festivals.items.isEmpty
            ? '현재 조회되는 축제가 없어요'
            : preferredCategorySet.isEmpty && !hasFavoritePreference
            ? '지금 방문하기 좋은 축제를 찾았어요'
            : '내 취향과 가까운 축제를 찾았어요',
        recommendationReason: featuredFestival == null
            ? '30일 이내 방문할 수 있는 축제를 찾고 있어요.'
            : homeRecommendationReason(
                featuredFestival,
                personality: personality,
                favoriteCategoryCounts: favoriteCategories,
                windowDays: windowDays,
              ),
        recommendationNotice: recommendationNotice,
        festivals: festivals,
        isRefreshing: false,
      );
    } catch (error) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: error.toString(),
      );
    }
  }
}

String homeRecommendationReason(
  FestivalSummary festival, {
  required FestivalPersonality? personality,
  required Map<FestivalCategory, int> favoriteCategoryCounts,
  int windowDays = 30,
}) {
  final favoriteCount = favoriteCategoryCounts[festival.category] ?? 0;
  final categoryLabel = _categoryLabel(festival.category);
  if (favoriteCount > 0) {
    return '관심 축제로 저장한 $categoryLabel 유형 $favoriteCount개와 비슷하고, '
        '$windowDays일 이내 방문할 수 있어 가장 먼저 추천했어요.';
  }
  final categories = personality == null
      ? const <FestivalCategory>{}
      : personality.hasRecommendationProfile
      ? personality.apiCategories
      : preferredCategories(personality.type);
  if (categories.contains(festival.category)) {
    return '${personality!.shortTitle} 성향이 선호하는 $categoryLabel 유형이며, '
        '$windowDays일 이내 방문할 수 있어 추천했어요.';
  }
  return '$windowDays일 이내 방문 가능한 축제 중 시작일이 가까워 추천했어요.';
}

String _categoryLabel(FestivalCategory category) => switch (category) {
  FestivalCategory.culture => '문화',
  FestivalCategory.nature => '자연',
  FestivalCategory.food => '먹거리',
  FestivalCategory.performance => '공연',
  FestivalCategory.tradition => '전통',
  FestivalCategory.other => '기타',
};

Set<FestivalCategory> preferredCategories(FestivalPersonalityType? type) {
  return switch (type) {
    FestivalPersonalityType.energeticExplorer => const {
      FestivalCategory.performance,
      FestivalCategory.food,
      FestivalCategory.culture,
    },
    FestivalPersonalityType.calmRomantic => const {
      FestivalCategory.nature,
      FestivalCategory.tradition,
      FestivalCategory.culture,
    },
    null => const {},
  };
}

Map<FestivalCategory, int> favoriteCategoryCounts(
  List<FavoritePlace> favorites,
) {
  final counts = <FestivalCategory, int>{};
  for (final favorite in favorites) {
    final category = FestivalCategory.values.where(
      (value) => value.name == favorite.categoryCode,
    );
    if (category.isEmpty) continue;
    counts.update(category.first, (count) => count + 1, ifAbsent: () => 1);
  }
  return counts;
}

List<FestivalSummary> rankHomeRecommendations(
  List<FestivalSummary> festivals, {
  required Set<FestivalCategory> preferredCategories,
  required Map<FestivalCategory, int> favoriteCategoryCounts,
}) {
  final ranked = [...festivals];
  int score(FestivalSummary festival) {
    final personalityScore = preferredCategories.contains(festival.category)
        ? 10
        : 0;
    final favoriteScore = (favoriteCategoryCounts[festival.category] ?? 0) * 20;
    return personalityScore + favoriteScore;
  }

  ranked.sort((a, b) {
    final scoreOrder = score(b).compareTo(score(a));
    if (scoreOrder != 0) return scoreOrder;
    final dateOrder = a.startDate.compareTo(b.startDate);
    if (dateOrder != 0) return dateOrder;
    return a.id.compareTo(b.id);
  });
  return ranked;
}

final homeViewModelProvider =
    NotifierProvider.autoDispose<HomeViewModel, HomeViewState>(
      HomeViewModel.new,
    );
