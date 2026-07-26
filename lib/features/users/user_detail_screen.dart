import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/permissions.dart';
import '../../core/theme.dart';
import '../../data/models/user.dart';
import '../../l10n/gen/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    setState(() => _isSaving = true);
    await context.read<UsersProvider>().updateRoleAndPermissions(widget.user.id, _role, _permissions.toList());
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.userDetailSaved)));
    }
  }

  Future<void> _toggleActive() async {
    final l10n = AppLocalizations.of(context);
    final isSelf = context.read<AuthProvider>().currentUser?.id == widget.user.id;
    if (isSelf && widget.user.isActive) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.userDetailCantDisableSelf)),
      );
      return;
    }

    final activate = !widget.user.isActive;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(activate ? l10n.userDetailActivateTitle : l10n.userDetailDeactivateTitle),
        content: Text(
          activate
              ? l10n.userDetailActivateBody(widget.user.name)
              : l10n.userDetailDeactivateBody(widget.user.name),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.commonCancel)),
          FilledButton(
            style: activate ? null : FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(activate ? l10n.userDetailActivate : l10n.userDetailDeactivate),
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
    final l10n = AppLocalizations.of(context);
    final user = widget.user;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.userDetailTitle)),
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
                          user.isActive ? l10n.commonActive : l10n.commonInactive,
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
          Text(l10n.userDetailRole, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 10),
          SegmentedButton<String>(
            segments: [
              ButtonSegment(value: 'admin', label: Text(l10n.commonAdmin)),
              ButtonSegment(value: 'kasir', label: Text(l10n.commonCashier)),
            ],
            selected: {_role},
            onSelectionChanged: (selection) => setState(() => _role = selection.first),
          ),
          const SizedBox(height: 24),
          Text(l10n.userDetailPermissions, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          for (final permission in AppPermissions.all)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(AppPermissions.label(permission, l10n)),
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
                : Text(l10n.userDetailSaveChanges),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
            ),
            onPressed: _toggleActive,
            child: Text(user.isActive ? l10n.userDetailDeactivateTitle : l10n.userDetailActivateTitle),
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
