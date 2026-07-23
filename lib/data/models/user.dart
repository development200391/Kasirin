class User {
  final int id;
  final String name;
  final String username;
  final String role;

  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.role,
  });

  factory User.fromMap(Map<String, Object?> map) {
    return User(
      id: map['id'] as int,
      name: map['name'] as String,
      username: map['username'] as String,
      role: map['role'] as String,
    );
  }
}
