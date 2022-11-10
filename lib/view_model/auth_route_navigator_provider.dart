import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample/model/auth_service.dart';

final authRouteNavigatorProvider =
    StateNotifierProvider<AuthRouteNavigatorNotifier, AuthRouteState>(
        (ref) => AuthRouteNavigatorNotifier(ref));

enum AuthRouteState {
  login,
  main,
}

class AuthRouteNavigatorNotifier extends StateNotifier<AuthRouteState> {
  AuthRouteNavigatorNotifier(this._ref) : super(AuthRouteState.login);

  final StateNotifierProviderRef _ref;

  bool get hasSession => _ref.read(authServiceProvider).currentUser != null;

  Future<bool> fetchSession() async {
    await _ref.read(authServiceProvider).fetchSession();
    return true;
  }

  Future<String?> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      await _ref
          .read(authServiceProvider)
          .loginWithEmailAndPassword(email, password);
      state = AuthRouteState.main;
      return null;
    } on AuthServiceException catch (e) {
      return e.message;
    } on Exception catch (_) {
      return 'Unknown exception';
    }
  }

  Future<String?> logout() async {
    try {
      await _ref.read(authServiceProvider).logout();
      state = AuthRouteState.login;
      return null;
    } on AuthServiceException catch (e) {
      return e.message;
    } on Exception catch (_) {
      return 'Unknown exception';
    }
  }
}
