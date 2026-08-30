import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/festival.dart';

enum FestivalMapFilter {
  all('전체', null),
  culture('문화', FestivalCategory.culture),
  nature('자연', FestivalCategory.nature),
  food('먹거리', FestivalCategory.food),
  performance('공연', FestivalCategory.performance),
  tradition('전통', FestivalCategory.tradition);

  const FestivalMapFilter(this.label, this.category);
  final String label;
  final FestivalCategory? category;
}

class MapViewState {
  const MapViewState({
    this.filter = FestivalMapFilter.all,
    this.festivals = const [],
    this.selectedFestivalId,
    this.isLocating = false,
    this.isLoading = false,
    this.errorMessage,
    this.analyses = const {},
    this.analyzingFestivalIds = const {},
  });

  final FestivalMapFilter filter;
  final List<FestivalSummary> festivals;
  final int? selectedFestivalId;
  final bool isLocating;
  final bool isLoading;
  final String? errorMessage;
  final Map<int, FestivalAnalysis> analyses;
  final Set<int> analyzingFestivalIds;

  List<FestivalSummary> get visibleFestivals {
    final category = filter.category;
    if (category == null) return festivals;
    return festivals
        .where((festival) => festival.category == category)
        .toList();
  }

  FestivalSummary? get selectedFestival {
    final id = selectedFestivalId;
    if (id == null) return null;
    for (final festival in festivals) {
      if (festival.id == id) return festival;
    }
    return null;
  }

  FestivalAnalysis? get selectedAnalysis => analyses[selectedFestivalId];
  bool get isSelectedFestivalAnalyzing =>
      selectedFestivalId != null &&
      analyzingFestivalIds.contains(selectedFestivalId);

  MapViewState copyWith({
    FestivalMapFilter? filter,
    List<FestivalSummary>? festivals,
    int? selectedFestivalId,
    bool? isLocating,
    bool? isLoading,
    String? errorMessage,
    bool clearSelectedFestival = false,
    bool clearError = false,
    Map<int, FestivalAnalysis>? analyses,
    Set<int>? analyzingFestivalIds,
  }) {
    return MapViewState(
      filter: filter ?? this.filter,
      festivals: festivals ?? this.festivals,
      selectedFestivalId: clearSelectedFestival
          ? null
          : selectedFestivalId ?? this.selectedFestivalId,
      isLocating: isLocating ?? this.isLocating,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      analyses: analyses ?? this.analyses,
      analyzingFestivalIds: analyzingFestivalIds ?? this.analyzingFestivalIds,
    );
  }
}

class MapViewModel extends AutoDisposeNotifier<MapViewState> {
  @override
  MapViewState build() {
    Future<void>.microtask(loadFestivals);
    return const MapViewState(isLoading: true);
  }

  Future<void> loadFestivals() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final page = await ref
          .read(festivalRepositoryProvider)
          .search(
            from: today,
            to: today.add(const Duration(days: 90)),
            size: 100,
          );
      state = state.copyWith(festivals: page.items, isLoading: false);
      // 지도에 노출되는 모든 축제를 가까운 순서부터 분석합니다. API가 축제별
      // 분석만 지원하므로 2개씩 호출해 서버 부하와 502/timeout 위험을 줄입니다.
      await analyzeNearest(
        latitude: 37.5283,
        longitude: 126.9326,
        limit: page.items.length,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  void selectFilter(FestivalMapFilter filter) {
    state = state.copyWith(filter: filter, clearSelectedFestival: true);
  }

  Future<void> selectFestival(int festivalId) async {
    state = state.copyWith(selectedFestivalId: festivalId);
    await analyzeFestival(festivalId);
  }

  Future<void> analyzeFestival(int festivalId) async {
    if (state.analyses.containsKey(festivalId) ||
        state.analyzingFestivalIds.contains(festivalId)) {
      return;
    }
    FestivalSummary? festival;
    for (final item in state.festivals) {
      if (item.id == festivalId) festival = item;
    }
    if (festival == null) return;
    final date = analysisDateForFestival(festival, DateTime.now());
    if (date == null) return;
    state = state.copyWith(
      analyzingFestivalIds: {...state.analyzingFestivalIds, festivalId},
    );
    try {
      final analysis = await ref
          .read(festivalRepositoryProvider)
          .analyze(festivalId, date);
      if (analysis.freshness == DataFreshness.unavailable) return;
      state = state.copyWith(
        analyses: {...state.analyses, festivalId: analysis},
      );
    } catch (_) {
      // 개별 마커 분석 실패는 다른 마커와 축제 목록 표시에 영향을 주지 않습니다.
    } finally {
      state = state.copyWith(
        analyzingFestivalIds: {...state.analyzingFestivalIds}
          ..remove(festivalId),
      );
    }
  }

  Future<void> analyzeNearest({
    required double latitude,
    required double longitude,
    int limit = 5,
  }) async {
    final candidates = nearestFestivals(
      state.visibleFestivals,
      latitude: latitude,
      longitude: longitude,
      limit: limit,
    ).where((festival) => !state.analyses.containsKey(festival.id)).toList();
    for (var index = 0; index < candidates.length; index += 2) {
      final end = (index + 2).clamp(0, candidates.length);
      await Future.wait(
        candidates
            .sublist(index, end)
            .map((festival) => analyzeFestival(festival.id)),
      );
    }
  }

  void clearSelectedFestival() {
    state = state.copyWith(clearSelectedFestival: true);
  }

  void setLocating(bool isLocating) {
    state = state.copyWith(isLocating: isLocating);
  }
}

DateTime? analysisDateForFestival(FestivalSummary festival, DateTime now) {
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
  if (today.isAfter(end)) return null;
  return today.isBefore(start) ? start : today;
}

List<FestivalSummary> nearestFestivals(
  List<FestivalSummary> festivals, {
  required double latitude,
  required double longitude,
  int limit = 5,
}) {
  final sorted = [...festivals]
    ..sort((a, b) {
      double distance(FestivalSummary festival) {
        final lat = festival.latitude - latitude;
        final lng = festival.longitude - longitude;
        return lat * lat + lng * lng;
      }

      return distance(a).compareTo(distance(b));
    });
  return sorted.take(limit).toList();
}

final mapViewModelProvider =
    NotifierProvider.autoDispose<MapViewModel, MapViewState>(MapViewModel.new);
