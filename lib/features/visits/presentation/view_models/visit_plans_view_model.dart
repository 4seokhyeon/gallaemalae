import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/domain/entities/visit.dart';

final visitPlansProvider = StreamProvider<List<Visit>>((ref) {
  return ref
      .watch(userActivityRepositoryProvider)
      .watchVisits()
      .map(
        (visits) =>
            visits.where((visit) => visit.id.startsWith('planned_')).toList(),
      );
});

class VisitPlansController extends Notifier<void> {
  @override
  void build() {}

  Future<void> save({
    required FestivalDetail festival,
    required DateTime visitDate,
    required int crowdScore,
  }) {
    return ref
        .read(userActivityRepositoryProvider)
        .saveVisit(
          Visit(
            id: 'planned_${festival.id}',
            placeId: '${festival.id}',
            placeName: festival.title,
            visitedAt: DateTime(visitDate.year, visitDate.month, visitDate.day),
            crowdLevel: crowdScore,
          ),
        );
  }

  Future<void> remove(int festivalId) {
    return ref
        .read(userActivityRepositoryProvider)
        .deleteVisit('planned_$festivalId');
  }
}

final visitPlansControllerProvider =
    NotifierProvider<VisitPlansController, void>(VisitPlansController.new);
