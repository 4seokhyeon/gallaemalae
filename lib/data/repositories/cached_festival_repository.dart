import 'dart:convert';

import 'package:gallaemalae/data/local/cache/festival_cache_store.dart';
import 'package:gallaemalae/domain/entities/festival.dart';
import 'package:gallaemalae/domain/repositories/festival_repository.dart';

class CachedFestivalRepository implements FestivalRepository {
  const CachedFestivalRepository(this._remote, this._cache);
  final FestivalRepository _remote;
  final FestivalCacheStore _cache;

  @override
  Future<FestivalPage> search({
    String? regionCode,
    DateTime? from,
    DateTime? to,
    Set<FestivalCategory> categories = const {},
    int page = 0,
    int size = 20,
  }) async {
    final categoryNames = categories.map((value) => value.name).toList()
      ..sort();
    final key = [
      'search',
      regionCode ?? '',
      _date(from),
      _date(to),
      categoryNames.join(','),
      page,
      size,
    ].join('|');
    try {
      final result = await _remote.search(
        regionCode: regionCode,
        from: from,
        to: to,
        categories: categories,
        page: page,
        size: size,
      );
      await _cache.write(key, jsonEncode(_pageToJson(result)));
      return result;
    } catch (_) {
      final cached = await _cache.read(key);
      if (cached == null) rethrow;
      return _pageFromJson(jsonDecode(cached) as Map<String, dynamic>);
    }
  }

  @override
  Future<FestivalDetail> getDetail(int id) async {
    final key = 'detail|$id';
    try {
      final result = await _remote.getDetail(id);
      await _cache.write(key, jsonEncode(_detailToJson(result)));
      return result;
    } catch (_) {
      final cached = await _cache.read(key);
      if (cached == null) rethrow;
      return _detailFromJson(jsonDecode(cached) as Map<String, dynamic>);
    }
  }

  @override
  Future<FestivalAnalysis> analyze(int id, DateTime date) async {
    final key = 'analysis|$id|${_date(date)}';
    try {
      final result = await _remote.analyze(id, date);
      await _cache.write(key, jsonEncode(_analysisToJson(result)));
      return result;
    } catch (_) {
      final cached = await _cache.read(key);
      if (cached == null) rethrow;
      return _analysisFromJson(
        jsonDecode(cached) as Map<String, dynamic>,
      ).copyWith(freshness: DataFreshness.stale);
    }
  }
}

String _date(DateTime? value) {
  if (value == null) return '';
  return '${value.year.toString().padLeft(4, '0')}-'
      '${value.month.toString().padLeft(2, '0')}-'
      '${value.day.toString().padLeft(2, '0')}';
}

Map<String, dynamic> _summaryToJson(FestivalSummary value) => {
  'id': value.id,
  'title': value.title,
  'regionCode': value.regionCode,
  'startDate': value.startDate.toIso8601String(),
  'endDate': value.endDate.toIso8601String(),
  'category': value.category.name,
  'address': value.address,
  'latitude': value.latitude,
  'longitude': value.longitude,
  'primaryImageUrl': value.primaryImageUrl,
};

FestivalSummary _summaryFromJson(Map<String, dynamic> json) => FestivalSummary(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  regionCode: json['regionCode'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  category: FestivalCategory.values.byName(json['category'] as String),
  address: json['address'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  primaryImageUrl: json['primaryImageUrl'] as String,
);

Map<String, dynamic> _pageToJson(FestivalPage value) => {
  'items': value.items.map(_summaryToJson).toList(),
  'page': value.page,
  'size': value.size,
  'totalElements': value.totalElements,
  'totalPages': value.totalPages,
};

FestivalPage _pageFromJson(Map<String, dynamic> json) => FestivalPage(
  items: (json['items'] as List<dynamic>)
      .map((item) => _summaryFromJson(item as Map<String, dynamic>))
      .toList(),
  page: (json['page'] as num).toInt(),
  size: (json['size'] as num).toInt(),
  totalElements: (json['totalElements'] as num).toInt(),
  totalPages: (json['totalPages'] as num).toInt(),
);

Map<String, dynamic> _detailToJson(FestivalDetail value) => {
  'id': value.id,
  'title': value.title,
  'regionCode': value.regionCode,
  'startDate': value.startDate.toIso8601String(),
  'endDate': value.endDate.toIso8601String(),
  'category': value.category.name,
  'externalSource': value.externalSource,
  'address': value.address,
  'latitude': value.latitude,
  'longitude': value.longitude,
  'primaryImageUrl': value.primaryImageUrl,
};

FestivalDetail _detailFromJson(Map<String, dynamic> json) => FestivalDetail(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  regionCode: json['regionCode'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  category: FestivalCategory.values.byName(json['category'] as String),
  externalSource: json['externalSource'] as String,
  address: json['address'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  primaryImageUrl: json['primaryImageUrl'] as String,
);

Map<String, dynamic> _analysisToJson(FestivalAnalysis value) => {
  'festivalId': value.festivalId,
  'predictedFor': value.predictedFor.toIso8601String(),
  'overall': {'score': value.overall.score, 'level': value.overall.level.name},
  'timeSlots': value.timeSlots
      .map(
        (slot) => {
          'period': slot.period.name,
          'startTime': slot.startTime,
          'endTime': slot.endTime,
          'score': slot.score,
          'level': slot.level.name,
        },
      )
      .toList(),
  'recommendedPeriod': value.recommendedPeriod.name,
  'busiestPeriod': value.busiestPeriod.name,
  'confidence': value.confidence,
  'basedAt': value.basedAt.toIso8601String(),
  'factors': value.factors,
  'dataUpdatedAt': value.dataUpdatedAt.toIso8601String(),
  'freshness': value.freshness.name,
};

FestivalAnalysis _analysisFromJson(Map<String, dynamic> json) {
  final overall = json['overall'] as Map<String, dynamic>;
  return FestivalAnalysis(
    festivalId: (json['festivalId'] as num).toInt(),
    predictedFor: DateTime.parse(json['predictedFor'] as String),
    overall: CrowdPrediction(
      score: (overall['score'] as num).toInt(),
      level: CrowdLevel.values.byName(overall['level'] as String),
    ),
    timeSlots: (json['timeSlots'] as List<dynamic>).map((item) {
      final slot = item as Map<String, dynamic>;
      return TimeSlotPrediction(
        period: DayPeriod.values.byName(slot['period'] as String),
        startTime: slot['startTime'] as String,
        endTime: slot['endTime'] as String,
        score: (slot['score'] as num).toInt(),
        level: CrowdLevel.values.byName(slot['level'] as String),
      );
    }).toList(),
    recommendedPeriod: DayPeriod.values.byName(
      json['recommendedPeriod'] as String,
    ),
    busiestPeriod: DayPeriod.values.byName(json['busiestPeriod'] as String),
    confidence: (json['confidence'] as num).toDouble(),
    basedAt: DateTime.parse(json['basedAt'] as String),
    factors: (json['factors'] as List<dynamic>).cast<String>(),
    dataUpdatedAt: DateTime.parse(json['dataUpdatedAt'] as String),
    freshness: DataFreshness.values.byName(json['freshness'] as String),
  );
}
