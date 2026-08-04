import 'dart:convert';

enum FestivalPersonalityType { energeticExplorer, calmRomantic }

class FestivalPersonality {
  const FestivalPersonality({
    required this.type,
    required this.answers,
    required this.completedAt,
  });
  final FestivalPersonalityType type;
  final List<int> answers;
  final DateTime completedAt;

  String get title => switch (type) {
    FestivalPersonalityType.energeticExplorer => '열정적인 축제 탐험가',
    FestivalPersonalityType.calmRomantic => '감성적인 여유 여행가',
  };
  String get shortTitle => switch (type) {
    FestivalPersonalityType.energeticExplorer => '열정적인 축제광',
    FestivalPersonalityType.calmRomantic => '감성적인 휴식가',
  };
  String get apiCode => switch (type) {
    FestivalPersonalityType.energeticExplorer => 'ENERGETIC_EXPLORER',
    FestivalPersonalityType.calmRomantic => 'CALM_ROMANTIC',
  };
  String get description => switch (type) {
    FestivalPersonalityType.energeticExplorer =>
      '북적이는 인파 속에서 에너지를 얻고 새로운 사람들과 어울리는 것을 즐겨요.',
    FestivalPersonalityType.calmRomantic =>
      '여유로운 동선과 감성적인 공간에서 깊이 있는 축제 경험을 즐겨요.',
  };

  String encode() => jsonEncode({
    'type': type.name,
    'answers': answers,
    'completedAt': completedAt.toIso8601String(),
  });

  static FestivalPersonality decode(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return FestivalPersonality(
      type: FestivalPersonalityType.values.byName(json['type'] as String),
      answers: (json['answers'] as List<dynamic>).cast<int>(),
      completedAt: DateTime.parse(json['completedAt'] as String),
    );
  }
}
