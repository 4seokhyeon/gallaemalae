import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/data/local/database_provider.dart';
import 'package:gallaemalae/core/network/dio_provider.dart';
import 'package:gallaemalae/core/network/festival_request_status.dart';
import 'package:gallaemalae/data/remote/festival_remote_data_source.dart';
import 'package:gallaemalae/data/repositories/api_festival_repository.dart';
import 'package:gallaemalae/data/repositories/cached_festival_repository.dart';
import 'package:gallaemalae/data/local/cache/festival_cache_store.dart';
import 'package:gallaemalae/data/repositories/drift_user_activity_repository.dart';
import 'package:gallaemalae/data/repositories/drift_personality_repository.dart';
import 'package:gallaemalae/data/repositories/geolocator_location_repository.dart';
import 'package:gallaemalae/domain/repositories/location_repository.dart';
import 'package:gallaemalae/domain/repositories/festival_repository.dart';
import 'package:gallaemalae/domain/repositories/personality_repository.dart';
import 'package:gallaemalae/domain/repositories/user_activity_repository.dart';

final userActivityRepositoryProvider = Provider<UserActivityRepository>((ref) {
  return DriftUserActivityRepository(ref.watch(appDatabaseProvider));
});

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return GeolocatorLocationRepository();
});

final personalityRepositoryProvider = Provider<PersonalityRepository>((ref) {
  return DriftPersonalityRepository(ref.watch(appDatabaseProvider));
});

final festivalRemoteDataSourceProvider = Provider<FestivalRemoteDataSource>(
  (ref) => FestivalRemoteDataSource(
    ref.watch(dioProvider),
    onListRetrying: ref
        .read(festivalRequestStatusProvider.notifier)
        .setRetrying,
  ),
);

final festivalCacheStoreProvider = Provider<FestivalCacheStore>((ref) {
  return FestivalCacheStore(ref.watch(appDatabaseProvider));
});

final festivalRepositoryProvider = Provider<FestivalRepository>((ref) {
  final remote = ApiFestivalRepository(
    ref.watch(festivalRemoteDataSourceProvider),
  );
  final cache = ref.watch(festivalCacheStoreProvider);
  return CachedFestivalRepository(remote, cache);
});
