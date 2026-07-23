import 'package:sqflite/sqflite.dart';

import '../../core/utils/password_hasher.dart';

const defaultAdminUsername = 'admin';
const defaultAdminPassword = 'admin123';

Future<void> seedDefaultAdmin(Database db) async {
  await db.insert('users', {
    'name': 'Admin',
    'username': defaultAdminUsername,
    'password_hash': hashPassword(defaultAdminPassword),
    'role': 'admin',
    'created_at': DateTime.now().toIso8601String(),
  });
}
