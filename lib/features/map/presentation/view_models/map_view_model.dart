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
  });

  final FestivalMapFilter filter;
  final List<FestivalSummary> festivals;
  final int? selectedFestivalId;
  final bool isLocating;
  final bool isLoading;
  final String? errorMessage;

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

  MapViewState copyWith({
    FestivalMapFilter? filter,
    List<FestivalSummary>? festivals,
    int? selectedFestivalId,
    bool? isLocating,
    bool? isLoading,
    String? errorMessage,
    bool clearSelectedFestival = false,
    bool clearError = false,
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
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  void selectFilter(FestivalMapFilter filter) {
    state = state.copyWith(filter: filter, clearSelectedFestival: true);
  }

  void selectFestival(int festivalId) {
    state = state.copyWith(selectedFestivalId: festivalId);
  }

  void clearSelectedFestival() {
    state = state.copyWith(clearSelectedFestival: true);
  }

  void setLocating(bool isLocating) {
    state = state.copyWith(isLocating: isLocating);
  }
}

final mapViewModelProvider =
    NotifierProvider.autoDispose<MapViewModel, MapViewState>(MapViewModel.new);
