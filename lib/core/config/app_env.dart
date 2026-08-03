abstract final class AppEnv {
  static const naverMapClientId = String.fromEnvironment('NAVER_MAP_CLIENT_ID');

  static bool get hasNaverMapClientId => naverMapClientId.isNotEmpty;
}
