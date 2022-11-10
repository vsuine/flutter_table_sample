abstract class RoutePath {
  Uri uri;
  RoutePath(String path) : uri = Uri(path: path);
  String get location;
}

abstract class AuthRoutePath extends RoutePath {
  AuthRoutePath(String path) : super(path);
  @override
  String get location;
}

class LoginPath extends AuthRoutePath {
  LoginPath() : super('/${LoginPath.path}');
  static const path = 'login';
  @override
  String get location => '/${LoginPath.path}';
}

abstract class MainAppRoutePath extends RoutePath {
  MainAppRoutePath(String path) : super(path);
  @override
  String get location;
}

class HomePath extends MainAppRoutePath {
  HomePath() : super('/${HomePath.path}');
  static const path = '';
  @override
  String get location => '/${HomePath.path}';
}
