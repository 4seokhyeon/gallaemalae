import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_view_model.freezed.dart';

@freezed
abstract class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    @Default('데이터를 분석하고 있어요') String summary,
    @Default(false) bool isRefreshing,
  }) = _HomeViewState;
}

class HomeViewModel extends Notifier<HomeViewState> {
  @override
  HomeViewState build() => const HomeViewState();

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(summary: '지금 방문하기 좋은 축제를 찾았어요', isRefreshing: false);
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, HomeViewState>(
  HomeViewModel.new,
);
