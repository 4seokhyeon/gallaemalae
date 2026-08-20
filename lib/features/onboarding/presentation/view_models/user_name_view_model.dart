import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gallaemalae/data/repositories/repository_providers.dart';

const userNameSettingKey = 'user_name_v1';

class UserNameViewModel extends AsyncNotifier<String?> {
  @override
  Future<String?> build() {
    return ref
        .watch(userActivityRepositoryProvider)
        .readSetting(userNameSettingKey);
  }

  Future<void> save(String name) async {
    final normalized = name.trim();
    if (normalized.isEmpty) {
      throw const FormatException('이름을 입력해 주세요.');
    }
    await ref
        .read(userActivityRepositoryProvider)
        .writeSetting(userNameSettingKey, normalized);
    state = AsyncData(normalized);
  }
}

final userNameProvider = AsyncNotifierProvider<UserNameViewModel, String?>(
  UserNameViewModel.new,
);
