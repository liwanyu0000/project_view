abstract class PageNotify {
  dynamic notify(String key, [dynamic data]);

  static const String login = 'login';
  static const String logout = 'logout';
}
