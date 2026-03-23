import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/dashboard_controller.dart';
import '../../theme/app_colors.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';
import '../../widgets/admin/stat_card.dart';
import 'dashboard_activity_feed_card.dart';
import 'dashboard_quick_actions_grid.dart';
import 'dashboard_upcoming_sessions_card.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  String _formatDate(DateTime d) {
    const weekdays = [
      'Lundi',
      'Mardi',
      'Mercredi',
      'Jeudi',
      'Vendredi',
      'Samedi',
      'Dimanche',
    ];
    const months = [
      '',
      'janvier',
      'février',
      'mars',
      'avril',
      'mai',
      'juin',
      'juillet',
      'août',
      'septembre',
      'octobre',
      'novembre',
      'décembre',
    ];
    return '${weekdays[d.weekday - 1]} ${d.day} ${months[d.month]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return AdminLayout(
      title: Tr.admin.dashboard.title.tr,
      topbarSubtitle: _formatDate(now),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Obx(() {
          final user = controller.currentUser.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Welcome banner
              _WelcomeBanner(userName: user?.email),
              const SizedBox(height: 20),

              // Stats row
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.euro_outlined,
                      iconColor: AppColors.or,
                      label: Tr.admin.dashboard.statRevenue.tr,
                      value: '—',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.camera_alt_outlined,
                      iconColor: AppColors.bleuOuvert,
                      label: Tr.admin.dashboard.statSessions.tr,
                      value: '—',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.people_outline,
                      iconColor: AppColors.terracotta,
                      label: Tr.admin.dashboard.statClients.tr,
                      value: '—',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.shopping_bag_outlined,
                      iconColor: AppColors.equestrian,
                      label: Tr.admin.dashboard.statOrders.tr,
                      value: '—',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Two-column grid
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 14, child: UpcomingSessionsCard()),
                  SizedBox(width: 20),
                  Expanded(flex: 10, child: ActivityFeedCard()),
                ],
              ),
              const SizedBox(height: 20),

              // Quick actions
              const QuickActionsGrid(),
            ],
          );
        }),
      ),
    );
  }
}

class _WelcomeBanner extends StatelessWidget {
  const _WelcomeBanner({required this.userName});

  final String? userName;

  @override
  Widget build(BuildContext context) {
    final displayName = userName ?? '…';
    final firstPart = displayName.contains('@')
        ? displayName.split('@').first
        : displayName;
    // Capitalize first letter
    final name = firstPart.isNotEmpty
        ? firstPart[0].toUpperCase() + firstPart.substring(1)
        : firstPart;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.crepuscule,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${Tr.admin.dashboard.welcomeGreeting.tr} ',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: name,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: AppColors.or,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  Tr.admin.dashboard.welcomeSubtitle.tr,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
