import 'package:gallaemalae/domain/entities/festival_personality.dart';

abstract interface class PersonalityRepository {
  Future<FestivalPersonality?> load();
  Future<void> save(FestivalPersonality personality);
  Stream<FestivalPersonality?> watch();
}
