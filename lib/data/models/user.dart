import '../../core/permissions.dart';

class User {
  final int id;
  final String name;
  final String username;
  final String role;
  final bool isActive;
  final List<String> permissions;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
    this.isActive = true,
    this.permissions = const [],
  });

  bool hasPermission(String permission) => permissions.contains(permission);

  factory User.fromMap(Map<String, Object?> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      username: map['username'] as String,
      role: map['role'] as String,
      isActive: (map['is_active'] as int? ?? 1) == 1,
      permissions: AppPermissions.parse(map['permissions'] as String?),
    );
  }
}
