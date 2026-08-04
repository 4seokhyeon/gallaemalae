abstract final class AppRoutes {
  static const splash = '/';
  static const personalityTest = '/personality-test';
  static const personalityResult = '/personality-result';
  static const home = '/home';
  static const map = '/map';
  static const analysis = '/analysis';
  static const profile = '/profile';

  static String detail(String placeId) => '/detail/$placeId';
}
