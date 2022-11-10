import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample/view/navigation/route_path.dart';
import 'package:sample/view_model/auth_route_navigator_provider.dart';

class MainRouteInformationParser extends RouteInformationParser<RoutePath> {
  MainRouteInformationParser(this._ref);
  final WidgetRef _ref;
  @override
  Future<RoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    /// Web ページの url に値を入力したとき（初回アクセスも含む）に呼び出される
    /// OS から通知される RouteInformation をアプリの状態である RoutePath に変換する
    /// Web: url から現在のパスを解析する
    /// async な理由は auth guard、つまり認証チェックなどを行うなどのため
    /// つまり、リダイレクトなどはここで行う

    debugPrint('parseRouteInformation');
    debugPrint('\trouteInformation.location == ${routeInformation.location}');

    // セッションが保たれているならメインページへ
    if (_ref.read(authRouteNavigatorProvider.notifier).hasSession) {
      return HomePath();
    }
    await _ref.read(authRouteNavigatorProvider.notifier).fetchSession();

    final pathSegment = Uri.parse(routeInformation.location ?? '').pathSegments;
    final firstPath = pathSegment.isEmpty ? '' : pathSegment.first;
    switch (firstPath) {
      case LoginPath.path:
        return LoginPath();
      case HomePath.path:
        return HomePath();
    }
    return LoginPath();
  }

  @override
  RouteInformation? restoreRouteInformation(RoutePath configuration) {
    /// currentConfiguration の後に呼び出される
    /// currentConfiguration で得た RoutePath が持つ状態から RouteInformation に変換する
    /// location (url) が異なれば OS に通知する
    /// つまり、アプリの状態から Web の URL を更新するためのもの

    debugPrint('restoreRouteInformation');
    debugPrint('\tconfiguration.runtimeType: ${configuration.runtimeType}');
    return RouteInformation(location: configuration.location);
  }
}
