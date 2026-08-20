import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/domain/entities/visit.dart';

part 'analysis_view_model.freezed.dart';

const analysisSelectionSettingKey = 'analysis_selection_v1';

@freezed
sealed class AnalysisViewState with _$AnalysisViewState {
  const factory AnalysisViewState.selecting({
    required List<FestivalSummary> festivals,
  }) = AnalysisSelecting;

  const factory AnalysisViewState.result({
    required FestivalDetail festival,
    required FestivalAnalysis analysis,
    required DateTime visitDate,
  }) = AnalysisResult;
}

class AnalysisViewModel extends AutoDisposeAsyncNotifier<AnalysisViewState> {
  @override
  Future<AnalysisViewState> build() async {
    final activityRepository = ref.watch(userActivityRepositoryProvider);
    final saved = await activityRepository.readSetting(
      analysisSelectionSettingKey,
    );
    if (saved == null || saved.isEmpty) return _loadFestivals();

    try {
      final json = jsonDecode(saved) as Map<String, dynamic>;
      return _loadResult(
        (json['festivalId'] as num).toInt(),
        DateTime.parse(json['visitDate'] as String),
      );
    } catch (_) {
      await ref
          .read(userActivityRepositoryProvider)
          .writeSetting(analysisSelectionSettingKey, '');
    }

    final visits = await activityRepository.watchVisits().first;
    final upcomingPlan = nearestUpcomingPlan(visits, DateTime.now());
    if (upcomingPlan != null) {
      final festivalId = int.tryParse(upcomingPlan.placeId);
      if (festivalId != null) {
        return _loadResult(festivalId, upcomingPlan.visitedAt);
      }
    }
    return _loadFestivals();
  }

  Future<void> analyzeFestival(int festivalId, DateTime visitDate) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await _loadResult(festivalId, visitDate);
      await ref
          .read(userActivityRepositoryProvider)
          .writeSetting(
            analysisSelectionSettingKey,
            jsonEncode({
              'festivalId': festivalId,
              'visitDate': _date(visitDate),
            }),
          );
      return result;
    });
  }

  Future<void> chooseAnotherFestival() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(userActivityRepositoryProvider)
          .writeSetting(analysisSelectionSettingKey, '');
      return _loadFestivals();
    });
  }

  Future<AnalysisViewState> _loadFestivals() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final page = await ref
        .read(festivalRepositoryProvider)
        .search(from: today, to: today.add(const Duration(days: 90)), size: 5);
    return AnalysisViewState.selecting(festivals: page.items);
  }

  Future<AnalysisViewState> _loadResult(
    int festivalId,
    DateTime visitDate,
  ) async {
    final repository = ref.read(festivalRepositoryProvider);
    final festival = await repository.getDetail(festivalId);
    final analysis = await repository.analyze(festivalId, visitDate);
    return AnalysisViewState.result(
      festival: festival,
      analysis: analysis,
      visitDate: visitDate,
    );
  }
}

Visit? nearestUpcomingPlan(List<Visit> visits, DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  final upcoming =
      visits
          .where(
            (visit) =>
                visit.id.startsWith('planned_') &&
                !visit.visitedAt.isBefore(today),
          )
          .toList()
        ..sort((a, b) => a.visitedAt.compareTo(b.visitedAt));
  return upcoming.isEmpty ? null : upcoming.first;
}

String _date(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

final analysisViewModelProvider =
    AsyncNotifierProvider.autoDispose<AnalysisViewModel, AnalysisViewState>(
      AnalysisViewModel.new,
    );
