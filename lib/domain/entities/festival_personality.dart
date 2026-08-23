import 'dart:convert';

import 'package:gallaemalae/domain/entities/festival.dart';

enum FestivalPersonalityType { energeticExplorer, calmRomantic }

enum FestivalCrowdPreference { lively, moderate, relaxed }

enum FestivalTravelScope { local, nearby, nationwide }

class FestivalPersonality {
  const FestivalPersonality({
    required this.type,
    required this.answers,
    required this.completedAt,
    this.preferredCategories = const {},
    this.crowdPreference = FestivalCrowdPreference.moderate,
    this.preferredPeriod = DayPeriod.afternoon,
    this.travelScope = FestivalTravelScope.nationwide,
  });

  final FestivalPersonalityType type;
  final List<int> answers;
  final DateTime completedAt;
  final Set<FestivalCategory> preferredCategories;
  final FestivalCrowdPreference crowdPreference;
  final DayPeriod preferredPeriod;
  final FestivalTravelScope travelScope;

  bool get hasRecommendationProfile => answers.length == 4;

  String get title => switch (type) {
    FestivalPersonalityType.energeticExplorer => '활기찬 축제 탐험가',
    FestivalPersonalityType.calmRomantic => '여유로운 축제 여행가',
  };

  String get shortTitle => switch (type) {
    FestivalPersonalityType.energeticExplorer => '활기찬 탐험가',
    FestivalPersonalityType.calmRomantic => '여유로운 여행가',
  };

  String get apiCode => switch (type) {
    FestivalPersonalityType.energeticExplorer => 'ENERGETIC_EXPLORER',
    FestivalPersonalityType.calmRomantic => 'CALM_ROMANTIC',
  };

  String get description =>
      '$categoryLabel 콘텐츠와 $crowdLabel 분위기, $periodLabel 방문을 선호해요.';

  String get categoryLabel {
    if (preferredCategories.isEmpty ||
        preferredCategories.contains(FestivalCategory.other)) {
      return '다양한';
    }
    return preferredCategories.map(_categoryLabel).join('·');
  }

  String get crowdLabel => switch (crowdPreference) {
    FestivalCrowdPreference.lively => '활기찬 인파',
    FestivalCrowdPreference.moderate => '적당한 인파',
    FestivalCrowdPreference.relaxed => '한산한 분위기',
  };

  String get periodLabel => switch (preferredPeriod) {
    DayPeriod.morning => '아침',
    DayPeriod.afternoon => '낮·오후',
    DayPeriod.evening => '저녁',
  };

  String get travelScopeLabel => switch (travelScope) {
    FestivalTravelScope.local => '집 근처',
    FestivalTravelScope.nearby => '인접 지역',
    FestivalTravelScope.nationwide => '전국',
  };

  Set<FestivalCategory> get apiCategories =>
      preferredCategories.contains(FestivalCategory.other)
      ? const {}
      : preferredCategories;

  String encode() => jsonEncode({
    'type': type.name,
    'answers': answers,
    'completedAt': completedAt.toIso8601String(),
    'preferredCategories': preferredCategories
        .map((value) => value.name)
        .toList(),
    'crowdPreference': crowdPreference.name,
    'preferredPeriod': preferredPeriod.name,
    'travelScope': travelScope.name,
  });

  static FestivalPersonality decode(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return FestivalPersonality(
      type: FestivalPersonalityType.values.byName(json['type'] as String),
      answers: (json['answers'] as List<dynamic>).cast<int>(),
      completedAt: DateTime.parse(json['completedAt'] as String),
      preferredCategories:
          (json['preferredCategories'] as List<dynamic>? ?? const [])
              .map((value) => FestivalCategory.values.byName(value as String))
              .toSet(),
      crowdPreference: FestivalCrowdPreference.values.byName(
        json['crowdPreference'] as String? ??
            FestivalCrowdPreference.moderate.name,
      ),
      preferredPeriod: DayPeriod.values.byName(
        json['preferredPeriod'] as String? ?? DayPeriod.afternoon.name,
      ),
      travelScope: FestivalTravelScope.values.byName(
        json['travelScope'] as String? ?? FestivalTravelScope.nationwide.name,
      ),
    );
  }
}

String _categoryLabel(FestivalCategory category) => switch (category) {
  FestivalCategory.nature => '자연',
  FestivalCategory.food => '먹거리',
  FestivalCategory.performance => '공연',
  FestivalCategory.tradition => '전통',
  FestivalCategory.culture => '문화',
  FestivalCategory.other => '다양한',
};
