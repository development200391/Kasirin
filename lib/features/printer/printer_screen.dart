import 'package:flutter/material.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';

import '../../core/theme.dart';
import '../../l10n/gen/app_localizations.dart';
import 'printer_provider.dart';

class PrinterScreen extends StatelessWidget {
  const PrinterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<PrinterProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.printerTitle)),
      body: RefreshIndicator(
        onRefresh: provider.loadDevices,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _StatusCard(provider: provider),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l10n.printerPairedDevices, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                IconButton(
                  icon: provider.isLoadingDevices
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  onPressed: provider.isLoadingDevices ? null : provider.loadDevices,
                ),
              ],
            ),
            if (provider.devices.isEmpty && !provider.isLoadingDevices)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  l10n.printerNoPairedDevices,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              )
            else
              for (final device in provider.devices) _DeviceTile(device: device, provider: provider),
            const SizedBox(height: 24),
            Text(l10n.printerPaperSize, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            Row(
              children: [
                _PaperSizeChip(
                  label: '58mm',
                  selected: provider.paperWidthMm == 58,
                  onTap: () => provider.setPaperWidthMm(58),
                ),
                const SizedBox(width: 10),
                _PaperSizeChip(
                  label: '80mm',
                  selected: provider.paperWidthMm == 80,
                  onTap: () => provider.setPaperWidthMm(80),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.printerAutoPrint, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              subtitle: Text(l10n.printerAutoPrintSubtitle, style: const TextStyle(fontSize: 12)),
              value: provider.autoPrint,
              onChanged: provider.setAutoPrint,
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: provider.isConnected
                  ? () async {
                      final success = await provider.testPrint();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(success ? l10n.printerTestPrintSuccess : l10n.printerTestPrintFailed)),
                        );
                      }
                    }
                  : null,
              icon: const Icon(Icons.print_outlined),
              label: Text(l10n.printerTestPrint),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.provider});

  final PrinterProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final connected = provider.isConnected;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: connected ? const Color(0xFFDCFCE7) : AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: connected ? AppColors.success : AppColors.border),
      ),
      child: Row(
        children: [
          Icon(
            connected ? Icons.bluetooth_connected : Icons.bluetooth_disabled,
            color: connected ? AppColors.success : AppColors.textSecondary,
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  connected ? l10n.printerConnected : l10n.printerNotConnected,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: connected ? AppColors.success : AppColors.textPrimary,
                  ),
                ),
                if (connected && provider.connectedName != null)
                  Text(provider.connectedName!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ],
            ),
          ),
          if (connected)
            TextButton(
              onPressed: provider.disconnectPrinter,
              child: Text(l10n.commonDisconnect, style: const TextStyle(color: AppColors.danger)),
            ),
        ],
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.device, required this.provider});

  final BluetoothInfo device;
  final PrinterProvider provider;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isConnected = provider.isConnected && provider.connectedAddress == device.macAdress;
    final isConnecting = provider.connectingAddress == device.macAdress;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isConnected ? AppColors.primary : AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.print_outlined, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(device.name.isEmpty ? l10n.printerUnnamedDevice : device.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(device.macAdress, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              ],
            ),
          ),
          if (isConnecting)
            const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
          else if (isConnected)
            Text(l10n.printerConnected, style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12))
          else
            TextButton(
              onPressed: () async {
                final success = await provider.connect(device);
                if (context.mounted && !success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.printerConnectFailed)),
                  );
                }
              },
              child: Text(l10n.commonConnect),
            ),
        ],
      ),
    );
  }
}

class _PaperSizeChip extends StatelessWidget {
  const _PaperSizeChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.primary,
      labelStyle: TextStyle(color: selected ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.bold),
      backgroundColor: AppColors.background,
    );
  }
}
