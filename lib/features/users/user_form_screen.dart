import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/permissions.dart';
import '../../l10n/gen/app_localizations.dart';
import 'users_provider.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _role = 'kasir';
  late Set<String> _permissions = AppPermissions.defaultsForRole(_role).toSet();
  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRoleChanged(String role) {
    setState(() {
      _role = role;
      _permissions = AppPermissions.defaultsForRole(role).toSet();
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context);
    final provider = context.read<UsersProvider>();
    final username = _usernameController.text.trim();

    setState(() => _isSaving = true);

    if (await provider.usernameExists(username)) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.userFormUsernameTaken)),
        );
      }
      return;
    }

    await provider.addUser(
      name: _nameController.text.trim(),
      username: username,
      password: _passwordController.text,
      role: _role,
      permissions: _permissions.toList(),
    );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.userFormTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: l10n.userFormFullName),
              validator: (v) => (v == null || v.trim().isEmpty) ? l10n.productFormNameRequired : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: l10n.loginUsername),
              validator: (v) => (v == null || v.trim().isEmpty) ? l10n.loginUsernameRequired : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.loginPassword),
              validator: (v) => (v == null || v.length < 6) ? l10n.userFormPasswordMinLength : null,
            ),
            const SizedBox(height: 24),
            Text(l10n.userDetailRole, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'admin', label: Text(l10n.commonAdmin)),
                ButtonSegment(value: 'kasir', label: Text(l10n.commonCashier)),
              ],
              selected: {_role},
              onSelectionChanged: (selection) => _onRoleChanged(selection.first),
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
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: _isSaving ? null : _submit,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation(Colors.white)),
                    )
                  : Text(l10n.usersAdd),
            ),
          ],
        ),
      ),
    );
  }
}
