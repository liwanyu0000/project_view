abstract class PageNotify {
  dynamic notify(String key, [dynamic data]);

  static const String login = 'login';
  static const String logout = 'logout';
  static const String houses = 'houses';
  static const String users = 'users';
  static const String permission = "permission";
}
