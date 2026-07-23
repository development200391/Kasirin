import '../../core/utils/password_hasher.dart';
import '../db/database_helper.dart';
import '../models/user.dart';

class AuthRepository {
  Future<User?> login(String username, String password) async {
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(
      'users',
      where: 'username = ? AND password_hash = ?',
      whereArgs: [username, hashPassword(password)],
      limit: 1,
    );

    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }
}
