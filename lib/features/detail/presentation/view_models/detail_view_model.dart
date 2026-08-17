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
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final analysisDate = today.isBefore(festival.startDate)
        ? festival.startDate
        : today.isAfter(festival.endDate)
        ? festival.endDate
        : today;
    final analysis = await repository.analyze(festivalId, analysisDate);
    return DetailViewState(festival: festival, analysis: analysis);
  }
}

final detailViewModelProvider = AsyncNotifierProvider.autoDispose
    .family<DetailViewModel, DetailViewState, int>(DetailViewModel.new);
