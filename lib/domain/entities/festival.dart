import 'package:freezed_annotation/freezed_annotation.dart';

part 'festival.freezed.dart';

enum FestivalCategory { culture, nature, food, performance, tradition, other }

enum CrowdLevel { low, medium, high, veryHigh }

enum DayPeriod { morning, afternoon, evening }

enum DataFreshness { fresh, stale, unavailable }

@freezed
abstract class FestivalSummary with _$FestivalSummary {
  const factory FestivalSummary({
    required int id,
    required String title,
    required String regionCode,
    required DateTime startDate,
    required DateTime endDate,
    required FestivalCategory category,
    required String address,
    required double latitude,
    required double longitude,
    required String primaryImageUrl,
  }) = _FestivalSummary;
}

@freezed
abstract class FestivalPage with _$FestivalPage {
  const factory FestivalPage({
    required List<FestivalSummary> items,
    required int page,
    required int size,
    required int totalElements,
    required int totalPages,
  }) = _FestivalPage;
}

@freezed
abstract class FestivalDetail with _$FestivalDetail {
  const factory FestivalDetail({
    required int id,
    required String title,
    required String regionCode,
    required DateTime startDate,
    required DateTime endDate,
    required FestivalCategory category,
    required String externalSource,
    required String address,
    required double latitude,
    required double longitude,
    required String primaryImageUrl,
  }) = _FestivalDetail;
}

@freezed
abstract class CrowdPrediction with _$CrowdPrediction {
  const factory CrowdPrediction({
    required int score,
    required CrowdLevel level,
  }) = _CrowdPrediction;
}

@freezed
abstract class TimeSlotPrediction with _$TimeSlotPrediction {
  const factory TimeSlotPrediction({
    required DayPeriod period,
    required String startTime,
    required String endTime,
    required int score,
    required CrowdLevel level,
  }) = _TimeSlotPrediction;
}

@freezed
abstract class FestivalAnalysis with _$FestivalAnalysis {
  const factory FestivalAnalysis({
    required int festivalId,
    required DateTime predictedFor,
    required CrowdPrediction overall,
    required List<TimeSlotPrediction> timeSlots,
    required DayPeriod recommendedPeriod,
    required DayPeriod busiestPeriod,
    required double confidence,
    required DateTime basedAt,
    required List<String> factors,
    required DateTime dataUpdatedAt,
    required DataFreshness freshness,
  }) = _FestivalAnalysis;
}
