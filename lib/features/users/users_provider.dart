import 'package:flutter/foundation.dart';

import '../../data/models/user.dart';
import '../../data/repositories/user_repository.dart';

class UsersProvider extends ChangeNotifier {
  UsersProvider({UserRepository? repository}) : _repository = repository ?? UserRepository() {
    load();
  }

  final UserRepository _repository;

  List<User> _users = [];
  List<User> get users => _users;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _users = await _repository.getAll();

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> usernameExists(String username) => _repository.usernameExists(username);

  Future<void> addUser({
    required String name,
    required String username,
    required String password,
    required String role,
    required List<String> permissions,
  }) async {
    await _repository.add(
      name: name,
      username: username,
      password: password,
      role: role,
      permissions: permissions,
    );
    await load();
  }

  Future<void> updateRoleAndPermissions(int id, String role, List<String> permissions) async {
    await _repository.updateRoleAndPermissions(id, role, permissions);
    await load();
  }

  Future<void> setActive(int id, bool isActive) async {
    await _repository.setActive(id, isActive);
    await load();
  }
}
