import 'package:chatapp/dio/models/user.dart';
import 'package:chatapp/dio/repositories/user_repository.dart';
import 'package:flutter/material.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final UserRepository _userRepository;

  AuthProvider({required UserRepository userRepository})
    : _userRepository = userRepository;

  AuthStatus _status = AuthStatus.initial;

  AuthStatus get status => _status;
  User? _currentUser;
  User? get currentUser => currentUser;

  String? _errorMessage;
  String? get errorMessasge => _errorMessage;

  Future<bool> login(String username, String password) async {
    _status = AuthStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _userRepository.login(
        username: username,
        password: password,
      );
      _status = AuthStatus.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = e
          .toString(); // Getting the error message and convert it to String format.
      return false;
    }
  }

  Future<void> logout() async {
    _userRepository.logout();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
