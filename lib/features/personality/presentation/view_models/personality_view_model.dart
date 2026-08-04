import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/festival_personality.dart';

final personalityProvider = StreamProvider<FestivalPersonality?>((ref) {
  return ref.watch(personalityRepositoryProvider).watch();
});

class PersonalityTestController extends Notifier<List<int?>> {
  @override
  List<int?> build() => List<int?>.filled(5, null);

  void answer(int questionIndex, int optionIndex) {
    final updated = [...state];
    updated[questionIndex] = optionIndex;
    state = updated;
  }

  Future<FestivalPersonality> complete() async {
    final answers = state.map((answer) => answer ?? 0).toList();
    final result = FestivalPersonality(
      type: answers.where((answer) => answer == 0).length >= 3
          ? FestivalPersonalityType.energeticExplorer
          : FestivalPersonalityType.calmRomantic,
      answers: answers,
      completedAt: DateTime.now(),
    );
    await ref.read(personalityRepositoryProvider).save(result);
    ref.invalidate(personalityProvider);
    return result;
  }

  void reset() => state = List<int?>.filled(5, null);
}

final personalityTestControllerProvider =
    NotifierProvider<PersonalityTestController, List<int?>>(
      PersonalityTestController.new,
    );
