import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/constants.dart';
import '../../core/theme.dart';
import '../../data/models/backup_entry.dart';
import '../../data/repositories/backup_repository.dart';
import '../../l10n/gen/app_localizations.dart';
import '../auth/auth_provider.dart';
import 'backup_provider.dart';

String _formatSize(int bytes) {
  if (bytes >= 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '$bytes B';
}

class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  Future<void> _createBackup(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final provider = context.read<BackupProvider>();
    final success = await provider.createBackup();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? l10n.backupCreated : l10n.backupCreateFailed)),
    );
  }

  Future<void> _importFile(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final picked = await FilePicker.pickFile();
    if (picked?.path == null || !context.mounted) return;

    final provider = context.read<BackupProvider>();
    final success = await provider.importFile(picked!.path!);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? l10n.backupImported : l10n.backupImportInvalid)),
    );
  }

  Future<void> _restore(BuildContext context, BackupEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.backupRestoreTitle),
        content: Text(
          l10n.backupRestoreConfirm(entry.fileName, DateFormat('d MMM yyyy, HH:mm').format(entry.createdAt)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.commonCancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonRestore),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final provider = context.read<BackupProvider>();
    final success = await provider.restore(entry);

    if (!context.mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.backupRestoreFailed)),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(l10n.backupRestoredTitle),
        content: Text(l10n.backupRestoredBody),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().logout();
              Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
            },
            child: Text(l10n.commonOk),
          ),
        ],
      ),
    );
  }

  Future<void> _share(BuildContext context, BackupEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final path = await BackupRepository().backupFilePath(entry);
    await SharePlus.instance.share(
      ShareParams(files: [XFile(path)], text: '${l10n.backupScreenTitle} - ${entry.fileName}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<BackupProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.backupScreenTitle)),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: provider.load,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ElevatedButton.icon(
                    onPressed: provider.isWorking ? null : () => _createBackup(context),
                    icon: provider.isWorking
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
                          )
                        : const Icon(Icons.backup_outlined),
                    label: Text(l10n.backupNow),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.backupDescription,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: provider.isWorking ? null : () => _importFile(context),
                    icon: const Icon(Icons.file_upload_outlined),
                    label: Text(l10n.backupImportFile),
                  ),
                  const SizedBox(height: 24),
                  Text(l10n.backupHistory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  if (provider.history.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(l10n.backupEmpty, style: const TextStyle(color: AppColors.textSecondary)),
                      ),
                    )
                  else
                    for (final entry in provider.history) _BackupTile(entry: entry, onRestore: () => _restore(context, entry), onShare: () => _share(context, entry)),
                ],
              ),
            ),
    );
  }
}

class _BackupTile extends StatelessWidget {
  const _BackupTile({required this.entry, required this.onRestore, required this.onShare});

  final BackupEntry entry;
  final VoidCallback onRestore;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isImported = entry.source == BackupSource.imported;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.description_outlined, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('d MMM yyyy, HH:mm').format(entry.createdAt),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isImported ? const Color(0xFFDBEAFE) : const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        isImported ? l10n.commonImported : l10n.commonManual,
                        style: TextStyle(
                          color: isImported ? const Color(0xFF1D4ED8) : const Color(0xFF16A34A),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(_formatSize(entry.sizeBytes), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onShare,
            icon: const Icon(Icons.ios_share_outlined, color: AppColors.textSecondary),
            tooltip: l10n.commonShare,
          ),
          TextButton(onPressed: onRestore, child: Text(l10n.commonRestore)),
        ],
      ),
    );
  }
}
