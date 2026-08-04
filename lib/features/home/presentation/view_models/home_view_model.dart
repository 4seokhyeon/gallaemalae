import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gallaemalae/features/personality/presentation/view_models/personality_view_model.dart';

part 'home_view_model.freezed.dart';

@freezed
abstract class HomeViewState with _$HomeViewState {
  const factory HomeViewState({
    @Default('데이터를 분석하고 있어요') String summary,
    @Default(false) bool isRefreshing,
  }) = _HomeViewState;
}

class HomeViewModel extends AutoDisposeNotifier<HomeViewState> {
  @override
  HomeViewState build() {
    ref.watch(personalityProvider);
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
    state = state.copyWith(isRefreshing: true);
    await Future<void>.delayed(const Duration(milliseconds: 300));
    state = state.copyWith(summary: '지금 방문하기 좋은 축제를 찾았어요', isRefreshing: false);
  }
}

final homeViewModelProvider =
    NotifierProvider.autoDispose<HomeViewModel, HomeViewState>(
      HomeViewModel.new,
    );
