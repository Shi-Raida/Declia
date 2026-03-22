import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/session_type.dart';
import '../../controllers/dashboard_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';
import '../../widgets/admin/session_type_tag.dart';
import '../../widgets/admin/stat_card.dart';
import 'session_type_color.dart';

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
      title: Tr.dashboardTitle.tr,
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
                      label: Tr.dashboardStatRevenue.tr,
                      value: '—',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.camera_alt_outlined,
                      iconColor: AppColors.bleuOuvert,
                      label: Tr.dashboardStatSessions.tr,
                      value: '—',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.people_outline,
                      iconColor: AppColors.terracotta,
                      label: Tr.dashboardStatClients.tr,
                      value: '—',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.shopping_bag_outlined,
                      iconColor: AppColors.equestrian,
                      label: Tr.dashboardStatOrders.tr,
                      value: '—',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Two-column grid
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 14, child: _UpcomingSessionsCard()),
                  const SizedBox(width: 20),
                  Expanded(flex: 10, child: _ActivityFeedCard()),
                ],
              ),
              const SizedBox(height: 20),

              // Quick actions
              _QuickActionsGrid(),
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
                        text: '${Tr.dashboardWelcomeGreeting.tr} ',
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
                  Tr.dashboardWelcomeSubtitle.tr,
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

class _UpcomingSessionsCard extends StatelessWidget {
  // Placeholder data
  final _items = const [
    _SessionPlaceholder(
      date: 'Mar 22',
      time: '10:00',
      client: 'Martin Sophie',
      type: SessionType.family,
    ),
    _SessionPlaceholder(
      date: 'Mar 23',
      time: '14:30',
      client: 'Dubois Marie',
      type: SessionType.maternity,
    ),
    _SessionPlaceholder(
      date: 'Mar 25',
      time: '09:00',
      client: 'Laurent Thomas',
      type: SessionType.portrait,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
            child: Row(
              children: [
                Text(
                  Tr.dashboardUpcomingSessions.tr,
                  style: AppTypography.heading4(),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.adminPlanning),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.bleuOuvert,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    Tr.dashboardSeeAll.tr,
                    style: AppTypography.bodySmall().copyWith(
                      color: AppColors.bleuOuvert,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          ..._items.map((item) => _SessionItemRow(item: item)),
        ],
      ),
    );
  }
}

class _SessionPlaceholder {
  const _SessionPlaceholder({
    required this.date,
    required this.time,
    required this.client,
    required this.type,
  });

  final String date;
  final String time;
  final String client;
  final SessionType type;
}

class _SessionItemRow extends StatelessWidget {
  const _SessionItemRow({required this.item});

  final _SessionPlaceholder item;

  @override
  Widget build(BuildContext context) {
    final color = item.type.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Date block
          Container(
            width: 52,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  item.date.split(' ').last,
                  style: AppTypography.statValue().copyWith(fontSize: 20),
                ),
                Text(
                  item.date.split(' ').first,
                  style: AppTypography.sectionTitle(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.client,
                  style: AppTypography.bodyMedium().copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColors.pierre,
                    ),
                    const SizedBox(width: 4),
                    Text(item.time, style: AppTypography.bodySmall()),
                  ],
                ),
              ],
            ),
          ),
          SessionTypeTag(label: item.type.name, color: color),
        ],
      ),
    );
  }
}

class _ActivityFeedCard extends StatelessWidget {
  final _activities = const [
    _ActivityItem(
      color: AppColors.success,
      text: 'Nouvelle commande #CMD-024',
      time: 'Il y a 2h',
    ),
    _ActivityItem(
      color: AppColors.bleuOuvert,
      text: 'Client Martin Sophie a validé sa galerie',
      time: 'Il y a 4h',
    ),
    _ActivityItem(
      color: AppColors.or,
      text: 'Nouveau client ajouté',
      time: 'Il y a 6h',
    ),
    _ActivityItem(
      color: AppColors.terracotta,
      text: 'Facture #INV-042 créée',
      time: 'Hier',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
            child: Text(
              Tr.dashboardRecentActivity.tr,
              style: AppTypography.heading4(),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          ..._activities.map((a) => _ActivityRow(item: a)),
        ],
      ),
    );
  }
}

class _ActivityItem {
  const _ActivityItem({
    required this.color,
    required this.text,
    required this.time,
  });

  final Color color;
  final String text;
  final String time;
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item});

  final _ActivityItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.text,
                  style: AppTypography.bodySmall().copyWith(
                    color: AppColors.encre,
                  ),
                ),
                const SizedBox(height: 2),
                Text(item.time, style: AppTypography.bodySmall()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  final _actions = const [
    _QuickActionItem(
      icon: Icons.camera_alt_outlined,
      label: 'Nouvelle séance',
      route: AppRoutes.adminPlanning,
    ),
    _QuickActionItem(
      icon: Icons.photo_library_outlined,
      label: 'Créer galerie',
      route: AppRoutes.adminGalleries,
    ),
    _QuickActionItem(
      icon: Icons.person_add_outlined,
      label: 'Nouveau client',
      route: AppRoutes.adminClientNew,
    ),
    _QuickActionItem(
      icon: Icons.receipt_long_outlined,
      label: 'Nouvelle facture',
      route: AppRoutes.adminInvoicing,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(Tr.dashboardQuickActions.tr, style: AppTypography.heading4()),
        const SizedBox(height: 12),
        Row(
          children: _actions.map((action) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: action == _actions.last ? 0 : 12,
                ),
                child: _QuickActionCard(item: action),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _QuickActionItem {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.item});

  final _QuickActionItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(item.route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.bleuOuvert.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 22, color: AppColors.bleuOuvert),
            ),
            const SizedBox(height: 10),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall().copyWith(
                color: AppColors.encre,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
