import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/pos/dashboard_screen.dart';

void main() {
  runApp(const KasirinApp());
}

class KasirinApp extends StatelessWidget {
  const KasirinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.login,
        routes: {
          AppRoutes.login: (context) => const LoginScreen(),
          AppRoutes.dashboard: (context) => const DashboardScreen(),
        },
      ),
    );
  }
}
