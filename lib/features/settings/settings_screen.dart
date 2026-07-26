import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../l10n/gen/app_localizations.dart';
import '../auth/auth_provider.dart';
import 'locale_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = context.watch<AuthProvider>().currentUser;
    final locale = context.watch<LocaleProvider>().locale;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Icon(Icons.person, color: Colors.white),
            ),
            title: Text(user?.name ?? '-'),
            subtitle: Text(user?.role == 'admin' ? l10n.commonAdmin : l10n.commonCashier),
          ),
          const SizedBox(height: 24),
          Text(l10n.settingsLanguage, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          _LanguageTile(
            label: l10n.languageIndonesian,
            selected: locale.languageCode == 'id',
            onTap: () => context.read<LocaleProvider>().setLocale(const Locale('id')),
          ),
          _LanguageTile(
            label: l10n.languageEnglish,
            selected: locale.languageCode == 'en',
            onTap: () => context.read<LocaleProvider>().setLocale(const Locale('en')),
          ),
          _LanguageTile(
            label: l10n.languageJapanese,
            selected: locale.languageCode == 'ja',
            onTap: () => context.read<LocaleProvider>().setLocale(const Locale('ja')),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            },
            icon: const Icon(Icons.logout, color: AppColors.danger),
            label: Text(l10n.settingsLogout, style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: selected ? AppColors.primary : AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
              if (selected) const Icon(Icons.check_circle, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}
