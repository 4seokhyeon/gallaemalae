import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/festival.dart';

part 'detail_view_model.freezed.dart';

@freezed
abstract class DetailViewState with _$DetailViewState {
  const factory DetailViewState({
    required FestivalDetail festival,
    required FestivalAnalysis analysis,
  }) = _DetailViewState;
}

class DetailViewModel
    extends AutoDisposeFamilyAsyncNotifier<DetailViewState, int> {
  @override
  Future<DetailViewState> build(int festivalId) async {
    final repository = ref.watch(festivalRepositoryProvider);
    final festival = await repository.getDetail(festivalId);
    // TODO: 서버의 과거 혼잡도 응답 확인 후 방문일 기반 날짜로 복원합니다.
    final analysisDate = DateTime(2026, 7, 19);
    final analysis = await repository.analyze(festivalId, analysisDate);
    return DetailViewState(festival: festival, analysis: analysis);
  }
}

final detailViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<DetailViewModel, DetailViewState, int>(DetailViewModel.new);
