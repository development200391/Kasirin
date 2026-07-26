import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants.dart';
import '../../core/permissions.dart';
import '../../core/theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/repositories/dashboard_repository.dart';
import '../auth/auth_provider.dart';
import '../settings/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _dashboardRepository = DashboardRepository();
  DashboardSummary? _summary;

  @override
  void initState() {
    super.initState();
    _loadSummary();
  }

  Future<void> _loadSummary() async {
    final summary = await _dashboardRepository.getTodaySummary();
    if (mounted) setState(() => _summary = summary);
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature belum tersedia')),
    );
  }

  void _showAccessDenied() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Anda tidak memiliki akses ke menu ini')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser;
    bool has(String permission) => user?.hasPermission(permission) ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _loadSummary,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _DashboardHeader(
              userName: user?.name ?? '',
              summary: _summary,
              onNotificationTap: () => _showComingSoon('Notifikasi'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Menu Utama',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  _MenuTile(
                    icon: Icons.point_of_sale_outlined,
                    iconBg: const Color(0xFFEEF2FF),
                    iconColor: AppColors.primary,
                    label: 'Mulai Transaksi',
                    locked: !has(AppPermissions.posTransaction),
                    onTap: has(AppPermissions.posTransaction)
                        ? () => Navigator.of(context).pushNamed(AppRoutes.pos).then((_) => _loadSummary())
                        : _showAccessDenied,
                  ),
                  _MenuTile(
                    icon: Icons.inventory_2_outlined,
                    iconBg: const Color(0xFFFEF3C7),
                    iconColor: const Color(0xFFB45309),
                    label: 'Kelola Produk',
                    locked: !has(AppPermissions.productsView),
                    onTap: has(AppPermissions.productsView)
                        ? () => Navigator.of(context).pushNamed(AppRoutes.products)
                        : _showAccessDenied,
                  ),
                  _MenuTile(
                    icon: Icons.bar_chart_outlined,
                    iconBg: const Color(0xFFFCE7F3),
                    iconColor: const Color(0xFFBE185D),
                    label: 'Laporan Penjualan',
                    locked: !has(AppPermissions.reportsView),
                    onTap: has(AppPermissions.reportsView)
                        ? () => Navigator.of(context).pushNamed(AppRoutes.reports)
                        : _showAccessDenied,
                  ),
                  _MenuTile(
                    icon: Icons.people_outline,
                    iconBg: const Color(0xFFDBEAFE),
                    iconColor: const Color(0xFF1D4ED8),
                    label: 'Pengguna',
                    locked: !has(AppPermissions.usersManage),
                    onTap: has(AppPermissions.usersManage)
                        ? () => Navigator.of(context).pushNamed(AppRoutes.users)
                        : _showAccessDenied,
                  ),
                  _MenuTile(
                    icon: Icons.settings_outlined,
                    iconBg: const Color(0xFFF3E8FF),
                    iconColor: const Color(0xFF7E22CE),
                    label: 'Pengaturan',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({required this.userName, required this.summary, required this.onNotificationTap});

  final String userName;
  final DashboardSummary? summary;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _HeaderClipper(),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 56),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primaryLight, Color(0xFF1D4ED8)],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: ClipOval(child: Image.asset('assets/logo.png', fit: BoxFit.cover)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Kasirin',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: onNotificationTap,
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Selamat datang,', style: TextStyle(color: Color(0xFFE0E7FF), fontSize: 15)),
              Text(
                userName,
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(label: 'Penjualan Hari Ini', value: formatCurrency(summary?.totalSales ?? 0)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(label: 'Transaksi', value: '${summary?.transactionCount ?? 0}'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFFE0E7FF), fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.onTap,
    this.locked = false,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Opacity(
        opacity: locked ? 0.5 : 1,
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: locked ? AppColors.background : iconBg, shape: BoxShape.circle),
                    child: Icon(locked ? Icons.lock_outline : icon, color: locked ? AppColors.textSecondary : iconColor, size: 22),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const dip = 36.0;
    final path = Path()
      ..lineTo(0, size.height - dip)
      ..quadraticBezierTo(size.width / 2, size.height, size.width, size.height - dip)
      ..lineTo(size.width, 0)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
