import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'core/constants.dart';
import 'core/theme.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/backup/backup_provider.dart';
import 'features/backup/backup_screen.dart';
import 'features/pos/cart_provider.dart';
import 'features/pos/dashboard_screen.dart';
import 'features/pos/pos_screen.dart';
import 'features/printer/printer_provider.dart';
import 'features/products/products_provider.dart';
import 'features/products/products_screen.dart';
import 'features/reports/period_report_provider.dart';
import 'features/reports/period_report_screen.dart';
import 'features/reports/reports_screen.dart';
import 'features/settings/locale_provider.dart';
import 'features/users/users_provider.dart';
import 'features/users/users_screen.dart';
import 'l10n/gen/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID');
  Intl.defaultLocale = 'id_ID';
  runApp(const KasirinApp());
}

class KasirinApp extends StatelessWidget {
  const KasirinApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PrinterProvider()..init()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()..init()),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) => MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: LocaleProvider.supportedLocales,
          initialRoute: AppRoutes.login,
          routes: {
            AppRoutes.login: (context) => const LoginScreen(),
            AppRoutes.dashboard: (context) => const DashboardScreen(),
            AppRoutes.products: (context) => ChangeNotifierProvider(
              create: (_) => ProductsProvider(),
              child: const ProductsScreen(),
            ),
            AppRoutes.pos: (context) => MultiProvider(
              providers: [
                ChangeNotifierProvider(create: (_) => ProductsProvider()),
                ChangeNotifierProvider(create: (_) => CartProvider()),
              ],
              child: const PosScreen(),
            ),
            AppRoutes.reports: (context) => const ReportsScreen(),
            AppRoutes.periodReports: (context) => ChangeNotifierProvider(
              create: (_) => PeriodReportProvider(),
              child: const PeriodReportScreen(),
            ),
            AppRoutes.users: (context) => ChangeNotifierProvider(
              create: (_) => UsersProvider(),
              child: const UsersScreen(),
            ),
            AppRoutes.backup: (context) => ChangeNotifierProvider(
              create: (_) => BackupProvider(),
              child: const BackupScreen(),
            ),
          },
        ),
      ),
    );
  }
}
