import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample/view/auth/login_view.dart';
import 'package:sample/view/main_app/main_view.dart';
import 'package:sample/view/navigation/route_path.dart';
import 'package:sample/view_model/auth_route_navigator_provider.dart';

/// RoiuterDelegate は 渡された設定に基づいて状態を復元する役割
class MainRouterDelegate extends RouterDelegate<RoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final WidgetRef _ref;

  MainRouterDelegate(this._ref) : navigatorKey = GlobalKey<NavigatorState>();

  // @override
  // Future<bool> popRoute() async {
  //   /// 戻るボタンが押された時の挙動、Web のブラウザバックは関係ない
  //   /// 基本は PopNavigatorRouterDelegateMixin を with で mixin する
  //   /// false を返すとアプリ全体をポップする、つまりアプリを閉じる
  //   /// 非同期処理を行わない場合は SynchronousFuture で返却すべき
  //   debugPrint('popRoute');

  //   // 基本機能は PopNavigatorRouterDelegateMixin が提供するので overrideしなくてもいい
  //   // PopNavigatorRouterDelegateMixin が提供するのは以下
  //   final NavigatorState? navigator = navigatorKey.currentState;
  //   if (navigator == null) {
  //     return SynchronousFuture<bool>(false);
  //   }
  //   return navigator.maybePop();
  //   // maybePop は Navigator の pages stack がなくなるまでポップする
  //   // stack がなくなったら false が返る
  //   // stack がなくても戻るボタンでアプリを閉じてほしくない場合
  //   // 例えば bottom navigation bar でタブ移動の履歴をたどるような場合には向かない
  // }

  @override
  RoutePath? get currentConfiguration {
    /// Router が再構築によって経路情報が変更された可能性を検出したときに呼び出される。
    /// 現在のアプリの状態からユーザー定義クラス (RoutePath) を返す

    debugPrint('currentConfiguration');
    switch (_ref.watch(authRouteNavigatorProvider)) {
      case AuthRouteState.login:
        return LoginPath();
      case AuthRouteState.main:
        return HomePath();
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 状態によって返す widget を切り替える
    /// notifyListeners が呼び出された後に rebuild される

    debugPrint('build');
    return Navigator(
        key: navigatorKey,
        pages: [
          if (_ref.read(authRouteNavigatorProvider) == AuthRouteState.login)
            const MaterialPage(child: LoginView()),
          if (_ref.read(authRouteNavigatorProvider) == AuthRouteState.main)
            const MaterialPage(child: HomeView()),
        ],
        onPopPage: _onPopPage);
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    /// Navigator.pop のコールバック関数、Android の戻るボタンが押されたときなど？
    /// web の ブラウザバックは該当しない、ブラウザバックは RouteInformationParser が走る
    debugPrint('_onPopPage');
    debugPrint('\t${route.runtimeType}');
    if (!route.didPop(result)) return false;
    return true;
  }

  @override
  Future<void> setNewRoutePath(RoutePath configuration) async {
    /// parseRouteInformation で解析された RoutePath から状態を更新する
    /// setNewRoutePath の後に notifyListerners を呼び出すべき
    /// 非同期処理を行わない場合 SynchronousFuture で返却すべき

    debugPrint('setNewRoutePath');
    debugPrint('\tget: ${configuration.runtimeType}');
    return SynchronousFuture<void>(null);
  }

  // @override
  // Future<void> setRestoredRoutePath(RoutePath configuration) {
  //   /// 状態の復元中に Router によって呼び出される
  //   return setNewRoutePath(configuration); // デフォルト
  // }

  // @override
  // Future<void> setInitialRoutePath(RoutePath configuration) {
  //   /// アプリ起動時にのみ呼び出される状態更新処理
  //   debugPrint('setInitialRoutePath');
  //   return SynchronousFuture<void>(null);
  // }
}
