import 'package:gallaemalae/domain/entities/favorite_place.dart';
import 'package:gallaemalae/domain/entities/visit.dart';

abstract interface class UserActivityRepository {
  Stream<List<Visit>> watchVisits();
  Future<void> saveVisit(Visit visit);
  Future<void> deleteVisit(String id);

  Stream<List<FavoritePlace>> watchFavorites();
  Future<void> saveFavorite(FavoritePlace place);
  Future<void> deleteFavorite(String placeId);

  Future<String?> readSetting(String key);
  Future<void> writeSetting(String key, String value);
  Future<void> deleteSetting(String key);
}
