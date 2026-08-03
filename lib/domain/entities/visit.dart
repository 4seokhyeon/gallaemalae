import 'package:freezed_annotation/freezed_annotation.dart';

part 'visit.freezed.dart';

@freezed
abstract class Visit with _$Visit {
  const factory Visit({
    required String id,
    required String placeId,
    required String placeName,
    required DateTime visitedAt,
    required int crowdLevel,
  }) = _Visit;
}
