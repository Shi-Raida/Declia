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
          _buildHeader(),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionLabel(Tr.adminSectionGeneral.tr),
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
                  _buildSectionLabel(Tr.adminSectionManagement.tr),
                  _buildNavItem(
                    route: AppRoutes.adminShop,
                    icon: Icons.storefront_outlined,
                    label: Tr.adminSidebarShop.tr,
                  ),
                  _buildNavItem(
                    route: AppRoutes.adminInvoicing,
                    icon: Icons.receipt_long_outlined,
                    label: Tr.adminSidebarInvoicing.tr,
                  ),
                  _buildNavItem(
                    route: AppRoutes.adminStatistics,
                    icon: Icons.bar_chart_outlined,
                    label: Tr.adminSidebarStatistics.tr,
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
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Tr.appName.tr,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            Tr.adminBrandSubtitle.tr,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.pierre,
              letterSpacing: 2,
            ),
          ),
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
  }) {
    return Obx(() {
      final isActive = controller.currentRoute.value == route;
      return InkWell(
        onTap: () => controller.navigateTo(route),
        child: Container(
          height: 44,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.crepuscule.withValues(alpha: 0.6)
                : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: isActive ? AppColors.terracotta : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isActive ? Colors.white : AppColors.pierre,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                  color: isActive ? Colors.white : AppColors.pierre,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFooter() {
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
              radius: 16,
              backgroundColor: AppColors.terracotta,
              child: Text(
                initial,
                style: GoogleFonts.outfit(
                  fontSize: 13,
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
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user.role.name,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      color: AppColors.pierre,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
