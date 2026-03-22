import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/admin_shell_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../translations/translation_keys.dart';

class AdminSidebar extends GetView<AdminShellController> {
  const AdminSidebar({super.key});

  static const double width = 260;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: AppColors.crepusculeDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SidebarHeader(),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel(Tr.adminSectionPrincipal.tr),
                  _buildNavItem(
                    route: AppRoutes.adminDashboard,
                    icon: Icons.dashboard_outlined,
                    label: Tr.adminSidebarDashboard.tr,
                  ),
                  _buildNavItem(
                    route: AppRoutes.adminClients,
                    icon: Icons.people_outline,
                    label: Tr.adminSidebarClients.tr,
                  ),
                  _buildNavItem(
                    route: AppRoutes.adminPlanning,
                    icon: Icons.calendar_month_outlined,
                    label: Tr.adminSidebarPlanning.tr,
                  ),
                  _buildNavItem(
                    route: AppRoutes.adminGalleries,
                    icon: Icons.photo_library_outlined,
                    label: Tr.adminSidebarGalleries.tr,
                  ),
                  const SizedBox(height: 8),
                  _buildSectionLabel(Tr.adminSectionCommerce.tr),
                  _buildNavItem(
                    route: AppRoutes.adminOrders,
                    icon: Icons.shopping_bag_outlined,
                    label: Tr.adminSidebarOrders.tr,
                  ),
                  _buildNavItem(
                    route: AppRoutes.adminInvoicing,
                    icon: Icons.receipt_long_outlined,
                    label: Tr.adminSidebarInvoicing.tr,
                  ),
                  _buildNavItem(
                    route: AppRoutes.adminGiftCards,
                    icon: Icons.card_giftcard_outlined,
                    label: Tr.adminSidebarGiftCards.tr,
                  ),
                  _buildNavItem(
                    route: AppRoutes.adminPromotions,
                    icon: Icons.local_offer_outlined,
                    label: Tr.adminSidebarPromotions.tr,
                  ),
                  const SizedBox(height: 8),
                  _buildSectionLabel(Tr.adminSectionOutils.tr),
                  _buildNavItem(
                    route: AppRoutes.adminTasks,
                    icon: Icons.check_circle_outline,
                    label: Tr.adminSidebarTasks.tr,
                  ),
                  _buildNavItem(
                    route: AppRoutes.adminSettings,
                    icon: Icons.settings_outlined,
                    label: Tr.adminSidebarSettings.tr,
                  ),
                ],
              ),
            ),
          ),
          _SidebarUserFooter(controller: controller),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: AppColors.pierre,
          letterSpacing: 1.8,
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String route,
    required IconData icon,
    required String label,
    int? badge,
  }) {
    return Obx(() {
      final current = controller.currentRoute.value;
      final isActive = current == route || current.startsWith('$route/');
      return InkWell(
        onTap: () => controller.navigateTo(route),
        child: Container(
          height: 44,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 1),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.bleuOuvert.withValues(alpha: 0.25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive
                    ? AppColors.or
                    : Colors.white.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                    color: isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                  ),
                ),
              ),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.terracotta,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$badge',
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Row(
        children: [
          Text(
            'Declia',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.or.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'Beta',
              style: GoogleFonts.outfit(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppColors.or,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarUserFooter extends StatelessWidget {
  const _SidebarUserFooter({required this.controller});

  final AdminShellController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = controller.currentUser.value;
      if (user == null) return const SizedBox.shrink();

      final initial = user.email.isNotEmpty ? user.email[0].toUpperCase() : '?';

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.crepuscule.withValues(alpha: 0.5)),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.terracotta,
              child: Text(
                initial,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    user.email,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user.role.name.capitalize!,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.logout,
                size: 16,
                color: Colors.white.withValues(alpha: 0.4),
              ),
              onPressed: controller.logout,
              tooltip: 'Se déconnecter',
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      );
    });
  }
}
