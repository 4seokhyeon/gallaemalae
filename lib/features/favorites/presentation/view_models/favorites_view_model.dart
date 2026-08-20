import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';
import 'package:gallaemalae/domain/entities/favorite_place.dart';
import 'package:gallaemalae/domain/entities/festival.dart';

final favoritePlacesProvider = StreamProvider<List<FavoritePlace>>((ref) {
  return ref.watch(userActivityRepositoryProvider).watchFavorites();
});

final isFavoriteProvider = Provider.family<bool, int>((ref, festivalId) {
  final favorites = ref.watch(favoritePlacesProvider).valueOrNull ?? const [];
  return favorites.any((favorite) => favorite.placeId == '$festivalId');
});

class FavoritesController extends Notifier<void> {
  @override
  void build() {}

  Future<void> toggle(FestivalDetail festival) async {
    final repository = ref.read(userActivityRepositoryProvider);
    final favorites = ref.read(favoritePlacesProvider).valueOrNull ?? const [];
    final isFavorite = favorites.any(
      (favorite) => favorite.placeId == '${festival.id}',
    );
    if (isFavorite) {
      await repository.deleteFavorite('${festival.id}');
      return;
    }
    await repository.saveFavorite(
      FavoritePlace(
        placeId: '${festival.id}',
        name: festival.title,
        latitude: festival.latitude,
        longitude: festival.longitude,
        createdAt: DateTime.now(),
        categoryCode: festival.category.name,
      ),
    );
  }

  Future<void> remove(String festivalId) {
    return ref.read(userActivityRepositoryProvider).deleteFavorite(festivalId);
  }

  Future<void> clear(List<FavoritePlace> favorites) async {
    final repository = ref.read(userActivityRepositoryProvider);
    for (final favorite in favorites) {
      await repository.deleteFavorite(favorite.placeId);
    }
  }
}

final favoritesControllerProvider = NotifierProvider<FavoritesController, void>(
  FavoritesController.new,
);
