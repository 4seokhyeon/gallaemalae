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
    @Default('30일 이내 방문할 수 있는 축제예요.') String recommendationReason,
  }) = _HomeViewState;
}

class HomeViewModel extends AutoDisposeNotifier<HomeViewState> {
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

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final until = today.add(const Duration(days: 30));
      final personality = ref.read(personalityProvider).value;
      final preferredCategorySet = preferredCategories(personality?.type);
      final favorites =
          ref.read(favoritePlacesProvider).valueOrNull ??
          const <FavoritePlace>[];
      final favoriteCategories = favoriteCategoryCounts(favorites);
      final repository = ref.read(festivalRepositoryProvider);
      final response = await repository.search(
        from: today,
        to: until,
        size: 20,
      );
      final ranked = rankHomeRecommendations(
        response.items,
        preferredCategories: preferredCategorySet,
        favoriteCategoryCounts: favoriteCategories,
      ).take(3).toList();
      final festivals = response.copyWith(items: ranked);
      final hasFavoritePreference = favoriteCategories.isNotEmpty;
      state = state.copyWith(
        summary: festivals.items.isEmpty
            ? '현재 조회되는 축제가 없어요'
            : preferredCategorySet.isEmpty && !hasFavoritePreference
            ? '지금 방문하기 좋은 축제를 찾았어요'
            : '내 취향과 가까운 축제를 찾았어요',
        recommendationReason: hasFavoritePreference
            ? '내 관심 축제와 비슷한 유형을 우선하고 성향 검사 결과를 함께 반영했어요.'
            : preferredCategorySet.isNotEmpty
            ? '성향 검사에서 선호한 유형과 30일 이내 방문 가능 여부를 반영했어요.'
            : '30일 이내 방문할 수 있는 축제를 가까운 일정순으로 추천해요.',
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
