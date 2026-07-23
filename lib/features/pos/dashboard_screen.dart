import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../auth/auth_provider.dart';

/// Placeholder — UI Dashboard Kasir sesuai mockup dibangun di Fase 3.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Kasir')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Selamat datang, ${user?.name ?? ''}'),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                context.read<AuthProvider>().logout();
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              },
              child: const Text('Keluar'),
            ),
          ],
        ),
      ),
    );
  }
}
