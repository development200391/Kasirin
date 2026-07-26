import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../data/models/user.dart';
import 'user_detail_screen.dart';
import 'user_form_screen.dart';
import 'users_provider.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UsersProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Pengguna')),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.users.isEmpty
              ? const Center(
                  child: Text('Belum ada pengguna', style: TextStyle(color: AppColors.textSecondary)),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                  itemCount: provider.users.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => _UserTile(user: provider.users[index]),
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider.value(
              value: context.read<UsersProvider>(),
              child: const UserFormScreen(),
            ),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pengguna'),
      ),
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final isAdmin = user.role == 'admin';

    return Opacity(
      opacity: user.isActive ? 1 : 0.55,
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: context.read<UsersProvider>(),
                child: UserDetailScreen(user: user),
              ),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: AppColors.primaryLight.withValues(alpha: 0.25),
                  child: Text(
                    _initials(user.name),
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(
                        user.isActive ? '@${user.username}' : '@${user.username} · Nonaktif',
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isAdmin ? const Color(0xFFEDE9FE) : const Color(0xFFD1FAE5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    isAdmin ? 'Admin' : 'Kasir',
                    style: TextStyle(
                      color: isAdmin ? const Color(0xFF6D28D9) : const Color(0xFF047857),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }
}
