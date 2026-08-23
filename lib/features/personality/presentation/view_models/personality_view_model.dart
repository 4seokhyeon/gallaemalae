import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/domain/entities/festival_personality.dart';

const personalityCategoryOptions = [
  FestivalCategory.nature,
  FestivalCategory.food,
  FestivalCategory.performance,
  FestivalCategory.tradition,
  FestivalCategory.culture,
  FestivalCategory.other,
];

final personalityProvider = StreamProvider<FestivalPersonality?>((ref) {
  return ref.watch(personalityRepositoryProvider).watch();
});

class PersonalityTestController extends Notifier<List<int?>> {
  @override
  List<int?> build() => List<int?>.filled(4, null);

  void toggleCategory(int optionIndex) {
    final currentMask = state[0] ?? 0;
    final otherBit = 1 << 5;
    int nextMask;
    if (optionIndex == 5) {
      nextMask = currentMask == otherBit ? 0 : otherBit;
    } else {
      final bit = 1 << optionIndex;
      final withoutOther = currentMask & ~otherBit;
      if ((withoutOther & bit) != 0) {
        nextMask = withoutOther & ~bit;
      } else if (_selectedCount(withoutOther) < 2) {
        nextMask = withoutOther | bit;
      } else {
        return;
      }
    }
    final updated = [...state];
    updated[0] = nextMask == 0 ? null : nextMask;
    state = updated;
  }

  void answer(int questionIndex, int optionIndex) {
    final updated = [...state];
    updated[questionIndex] = optionIndex;
    state = updated;
  }

  Future<FestivalPersonality> complete() async {
    if (state.any((answer) => answer == null)) {
      throw StateError('모든 문항에 응답해 주세요.');
    }
    final answers = state.cast<int>();
    final categories = <FestivalCategory>{};
    for (var index = 0; index < personalityCategoryOptions.length; index++) {
      if ((answers[0] & (1 << index)) != 0) {
        categories.add(personalityCategoryOptions[index]);
      }
    }
    final crowdPreference = FestivalCrowdPreference.values[answers[1]];
    final result = FestivalPersonality(
      type: crowdPreference == FestivalCrowdPreference.lively
          ? FestivalPersonalityType.energeticExplorer
          : FestivalPersonalityType.calmRomantic,
      answers: answers,
      completedAt: DateTime.now(),
      preferredCategories: categories,
      crowdPreference: crowdPreference,
      preferredPeriod: DayPeriod.values[answers[2]],
      travelScope: FestivalTravelScope.values[answers[3]],
    );
    await ref.read(personalityRepositoryProvider).save(result);
    ref.invalidate(personalityProvider);
    return result;
  }

  void reset() => state = List<int?>.filled(4, null);
}

int _selectedCount(int mask) {
  var count = 0;
  while (mask != 0) {
    count += mask & 1;
    mask >>= 1;
  }
  return count;
}

final personalityTestControllerProvider =
    NotifierProvider<PersonalityTestController, List<int?>>(
      PersonalityTestController.new,
    );
