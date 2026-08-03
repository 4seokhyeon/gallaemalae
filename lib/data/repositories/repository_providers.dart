import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/data/local/database_provider.dart';
import 'package:gallaemalae/data/repositories/drift_user_activity_repository.dart';
import 'package:gallaemalae/domain/repositories/user_activity_repository.dart';

final userActivityRepositoryProvider = Provider<UserActivityRepository>((ref) {
  return DriftUserActivityRepository(ref.watch(appDatabaseProvider));
});
