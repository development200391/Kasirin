import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/permissions.dart';
import '../../core/theme.dart';
import '../../data/models/user.dart';
import '../auth/auth_provider.dart';
import 'users_provider.dart';

class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({super.key, required this.user});

  final User user;

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late String _role;
  late Set<String> _permissions;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _role = widget.user.role;
    _permissions = widget.user.permissions.toSet();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await context.read<UsersProvider>().updateRoleAndPermissions(widget.user.id, _role, _permissions.toList());
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perubahan disimpan')));
    }
  }

  Future<void> _toggleActive() async {
    final isSelf = context.read<AuthProvider>().currentUser?.id == widget.user.id;
    if (isSelf && widget.user.isActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda tidak bisa menonaktifkan akun sendiri')),
      );
      return;
    }

    final activate = !widget.user.isActive;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(activate ? 'Aktifkan Pengguna' : 'Nonaktifkan Pengguna'),
        content: Text(
          activate
              ? '${widget.user.name} akan bisa login kembali.'
              : '${widget.user.name} tidak akan bisa login sampai diaktifkan kembali.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          FilledButton(
            style: activate ? null : FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(activate ? 'Aktifkan' : 'Nonaktifkan'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    await context.read<UsersProvider>().setActive(widget.user.id, activate);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengguna')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: AppColors.primaryLight.withValues(alpha: 0.25),
                child: Text(
                  _initials(user.name),
                  style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('@${user.username}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: user.isActive ? AppColors.success : AppColors.textSecondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          user.isActive ? 'Aktif' : 'Nonaktif',
                          style: TextStyle(
                            color: user.isActive ? AppColors.success : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          const Text('Role Pengguna', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'admin', label: Text('Admin')),
              ButtonSegment(value: 'kasir', label: Text('Kasir')),
            ],
            selected: {_role},
            onSelectionChanged: (selection) => setState(() => _role = selection.first),
          ),
          const SizedBox(height: 24),
          const Text('Hak Akses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          for (final permission in AppPermissions.all)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(AppPermissions.labels[permission]!),
              value: _permissions.contains(permission),
              onChanged: (checked) => setState(() {
                if (checked == true) {
                  _permissions.add(permission);
                } else {
                  _permissions.remove(permission);
                }
              }),
            ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(Colors.white)),
                  )
                : const Text('Simpan Perubahan'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
            ),
            onPressed: _toggleActive,
            child: Text(user.isActive ? 'Nonaktifkan Pengguna' : 'Aktifkan Pengguna'),
          ),
        ],
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
