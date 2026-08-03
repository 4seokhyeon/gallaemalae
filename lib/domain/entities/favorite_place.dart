import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite_place.freezed.dart';

@freezed
abstract class FavoritePlace with _$FavoritePlace {
  const factory FavoritePlace({
    required String placeId,
    required String name,
    required double latitude,
    required double longitude,
    required DateTime createdAt,
  }) = _FavoritePlace;
}
