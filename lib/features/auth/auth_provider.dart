import 'package:flutter/foundation.dart';

import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  final AuthRepository _repository;

  User? _currentUser;
  User? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    final user = await _repository.login(username.trim(), password);

    _isLoading = false;
    if (user == null) {
      _hasError = true;
      notifyListeners();
      return false;
    }

    _currentUser = user;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
