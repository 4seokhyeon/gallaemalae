import 'package:flutter_riverpod/flutter_riverpod.dart';

enum CrowdFilter {
  all('전체'),
  relaxed('여유로운 곳'),
  popular('인기 폭발'),
  food('먹거리');

  const CrowdFilter(this.label);
  final String label;
}

class MapViewState {
  const MapViewState({
    this.filter = CrowdFilter.all,
    this.selectedPlaceId,
    this.isLocating = false,
  });

  final CrowdFilter filter;
  final String? selectedPlaceId;
  final bool isLocating;

  MapViewState copyWith({
    CrowdFilter? filter,
    String? selectedPlaceId,
    bool? isLocating,
    bool clearSelectedPlace = false,
  }) {
    return MapViewState(
      filter: filter ?? this.filter,
      selectedPlaceId: clearSelectedPlace
          ? null
          : selectedPlaceId ?? this.selectedPlaceId,
      isLocating: isLocating ?? this.isLocating,
    );
  }
}

class MapViewModel extends Notifier<MapViewState> {
  @override
  MapViewState build() => const MapViewState();

  void selectFilter(CrowdFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void selectPlace(String placeId) {
    state = state.copyWith(selectedPlaceId: placeId);
  }

  void clearSelectedPlace() {
    state = state.copyWith(clearSelectedPlace: true);
  }

  void setLocating(bool isLocating) {
    state = state.copyWith(isLocating: isLocating);
  }
}

final mapViewModelProvider = NotifierProvider<MapViewModel, MapViewState>(
  MapViewModel.new,
);
