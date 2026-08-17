import 'package:gallaemalae/data/remote/festival_remote_data_source.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/domain/repositories/festival_repository.dart';

class ApiFestivalRepository implements FestivalRepository {
  const ApiFestivalRepository(this._remote);

  final FestivalRemoteDataSource _remote;

  @override
  Future<FestivalPage> search({
    String? regionCode,
    DateTime? from,
    DateTime? to,
    Set<FestivalCategory> categories = const {},
    int page = 0,
    int size = 20,
  }) async {
    final json = await _remote.search({
      'regionCode': ?regionCode,
      if (from != null) 'from': _date(from),
      if (to != null) 'to': _date(to),
      if (categories.isNotEmpty)
        'categories': categories.map(_festivalCategoryToApi).toList(),
      'page': page,
      'size': size,
    });
    return FestivalPage(
      items: _list(json, 'items').map(_summary).toList(growable: false),
      page: _int(json, 'page'),
      size: _int(json, 'size'),
      totalElements: _int(json, 'totalElements'),
      totalPages: _int(json, 'totalPages'),
    );
  }

  @override
  Future<FestivalDetail> getDetail(int id) async {
    final json = await _remote.getDetail(id);
    return FestivalDetail(
      id: _int(json, 'id'),
      title: _string(json, 'title'),
      regionCode: _string(json, 'regionCode'),
      startDate: _dateTime(json, 'startDate'),
      endDate: _dateTime(json, 'endDate'),
      category: _festivalCategory(_string(json, 'category')),
      externalSource: _string(json, 'externalSource'),
      address: _string(json, 'address'),
      latitude: _double(json, 'latitude'),
      longitude: _double(json, 'longitude'),
      primaryImageUrl: _string(json, 'primaryImageUrl'),
    );
  }

  @override
  Future<FestivalAnalysis> analyze(int id, DateTime date) async {
    final json = await _remote.analyze(id, _date(date));
    final overall = _map(json, 'overall');
    return FestivalAnalysis(
      festivalId: _int(json, 'festivalId'),
      predictedFor: _dateTime(json, 'predictedFor'),
      overall: CrowdPrediction(
        score: _int(overall, 'score'),
        level: _crowdLevel(_string(overall, 'level')),
      ),
      timeSlots: _list(json, 'timeSlots')
          .map((slot) {
            return TimeSlotPrediction(
              period: _dayPeriod(_string(slot, 'period')),
              startTime: _string(slot, 'startTime'),
              endTime: _string(slot, 'endTime'),
              score: _int(slot, 'score'),
              level: _crowdLevel(_string(slot, 'level')),
            );
          })
          .toList(growable: false),
      recommendedPeriod: _dayPeriod(_string(json, 'recommendedPeriod')),
      busiestPeriod: _dayPeriod(_string(json, 'busiestPeriod')),
      confidence: _double(json, 'confidence'),
      basedAt: _dateTime(json, 'basedAt'),
      factors: _list(json, 'factors').map((e) => e.toString()).toList(),
      dataUpdatedAt: _dateTime(json, 'dataUpdatedAt'),
      freshness: _freshness(_string(json, 'freshness')),
    );
  }
}

FestivalSummary _summary(Map<String, dynamic> json) => FestivalSummary(
  id: _int(json, 'id'),
  title: _string(json, 'title'),
  regionCode: _string(json, 'regionCode'),
  startDate: _dateTime(json, 'startDate'),
  endDate: _dateTime(json, 'endDate'),
  category: _festivalCategory(_string(json, 'category')),
  address: _string(json, 'address'),
  latitude: _double(json, 'latitude'),
  longitude: _double(json, 'longitude'),
  primaryImageUrl: _string(json, 'primaryImageUrl'),
);

String _date(DateTime value) =>
    '${value.year.toString().padLeft(4, '0')}-'
    '${value.month.toString().padLeft(2, '0')}-'
    '${value.day.toString().padLeft(2, '0')}';

String _festivalCategoryToApi(FestivalCategory value) => switch (value) {
  FestivalCategory.culture => 'CULTURE',
  FestivalCategory.nature => 'NATURE',
  FestivalCategory.food => 'FOOD',
  FestivalCategory.performance => 'PERFORMANCE',
  FestivalCategory.tradition => 'TRADITION',
  FestivalCategory.other => 'OTHER',
};

FestivalCategory _festivalCategory(String value) => switch (value) {
  'CULTURE' => FestivalCategory.culture,
  'NATURE' => FestivalCategory.nature,
  'FOOD' => FestivalCategory.food,
  'PERFORMANCE' => FestivalCategory.performance,
  'TRADITION' => FestivalCategory.tradition,
  _ => FestivalCategory.other,
};

CrowdLevel _crowdLevel(String value) => switch (value) {
  'LOW' => CrowdLevel.low,
  'MEDIUM' => CrowdLevel.medium,
  'HIGH' => CrowdLevel.high,
  'VERY_HIGH' => CrowdLevel.veryHigh,
  _ => throw FormatException('알 수 없는 혼잡도: $value'),
};

DayPeriod _dayPeriod(String value) => switch (value) {
  'MORNING' => DayPeriod.morning,
  'AFTERNOON' => DayPeriod.afternoon,
  'EVENING' => DayPeriod.evening,
  _ => throw FormatException('알 수 없는 시간대: $value'),
};

DataFreshness _freshness(String value) => switch (value) {
  'FRESH' => DataFreshness.fresh,
  'STALE' => DataFreshness.stale,
  'UNAVAILABLE' => DataFreshness.unavailable,
  _ => throw FormatException('알 수 없는 데이터 상태: $value'),
};

String _string(Map<String, dynamic> json, String key) =>
    json[key] as String? ?? (throw FormatException('$key 값이 없습니다.'));
int _int(Map<String, dynamic> json, String key) =>
    (json[key] as num?)?.toInt() ?? (throw FormatException('$key 값이 없습니다.'));
double _double(Map<String, dynamic> json, String key) =>
    (json[key] as num?)?.toDouble() ?? (throw FormatException('$key 값이 없습니다.'));
DateTime _dateTime(Map<String, dynamic> json, String key) =>
    DateTime.parse(_string(json, key));
Map<String, dynamic> _map(Map<String, dynamic> json, String key) =>
    json[key] as Map<String, dynamic>? ??
    (throw FormatException('$key 값이 없습니다.'));
List<Map<String, dynamic>> _list(Map<String, dynamic> json, String key) =>
    (json[key] as List<dynamic>? ?? const [])
        .map((item) => item as Map<String, dynamic>)
        .toList(growable: false);
