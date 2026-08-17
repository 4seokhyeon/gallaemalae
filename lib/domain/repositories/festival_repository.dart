import 'package:gallaemalae/domain/entities/festival.dart';

abstract interface class FestivalRepository {
  Future<FestivalPage> search({
    String? regionCode,
    DateTime? from,
    DateTime? to,
    Set<FestivalCategory> categories = const {},
    int page = 0,
    int size = 20,
  });

  Future<FestivalDetail> getDetail(int id);

  Future<FestivalAnalysis> analyze(int id, DateTime date);
}
