import 'package:gallaemalae/domain/entities/favorite_place.dart';
import 'package:gallaemalae/domain/repositories/user_activity_repository.dart';

class WatchFavoritePlaces {
  const WatchFavoritePlaces(this._repository);

  final UserActivityRepository _repository;

  Stream<List<FavoritePlace>> call() => _repository.watchFavorites();
}
