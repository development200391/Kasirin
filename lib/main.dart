import 'package:flutter/material.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'features/auth/login_screen.dart';

void main() {
  runApp(const KasirinApp());
}

class KasirinApp extends StatelessWidget {
  const KasirinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
      },
    );
  }
}
