import '../../core/permissions.dart';
import '../../core/utils/password_hasher.dart';
import '../db/database_helper.dart';
import '../models/user.dart';

class UserRepository {
  Future<List<User>> getAll() async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('users', orderBy: 'name ASC');
    return rows.map(User.fromMap).toList();
  }

  Future<bool> usernameExists(String username) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query('users', where: 'username = ?', whereArgs: [username], limit: 1);
    return rows.isNotEmpty;
  }

  Future<int> add({
    required String name,
    required String username,
    required String password,
    required String role,
    required List<String> permissions,
  }) async {
    final db = await DatabaseHelper.instance.database;
    return db.insert('users', {
      'name': name,
      'username': username,
      'password_hash': hashPassword(password),
      'role': role,
      'is_active': 1,
      'permissions': AppPermissions.encode(permissions),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateRoleAndPermissions(int id, String role, List<String> permissions) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'users',
      {'role': role, 'permissions': AppPermissions.encode(permissions)},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> setActive(int id, bool isActive) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'users',
      {'is_active': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
