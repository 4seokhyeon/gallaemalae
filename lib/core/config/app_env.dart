abstract final class AppEnv {
  static const apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://galraemalrae-production.up.railway.app',
  );
  static const naverMapClientId = String.fromEnvironment('NAVER_MAP_CLIENT_ID');

  static bool get hasNaverMapClientId => naverMapClientId.isNotEmpty;
}
