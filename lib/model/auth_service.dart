import 'dart:math';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample/model/user_data.dart';
import 'package:uuid/uuid.dart';

final authServiceProvider =
    Provider<BaseAuthService>((ref) => MockAuthService());

abstract class BaseAuthService {
  UserData? get currentUser;

  /// ログインに失敗したら [AuthServiceException] を投げる
  Future<void> loginWithEmailAndPassword(String email, String password);
  Future<void> logout();
  // セッションが保持されているなら true、それ以外は false
  Future<bool> fetchSession();
}

class MockAuthService extends BaseAuthService {
  final Uuid _uuid = const Uuid();
  final Random _random = Random();
  MockAuthService();
  Future<void> _wait() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  UserData? _userData;

  @override
  UserData? get currentUser => _userData;

  @override
  Future<AuthServiceException?> loginWithEmailAndPassword(
      String email, String password) async {
    await _wait();
    _userData = UserData(id: _uuid.v4(), name: 'name:${_random.nextInt(100)}');
    return null;
  }

  @override
  Future<AuthServiceException?> logout() async {
    await _wait();
    return null;
  }

  @override
  Future<bool> fetchSession() async {
    await _wait();
    _userData = UserData(id: _uuid.v4(), name: 'name:${_random.nextInt(100)}');
    return true;
  }
}

class AuthServiceException implements Exception {
  final String message;
  const AuthServiceException(this.message);

  @override
  String toString() => message;
}
