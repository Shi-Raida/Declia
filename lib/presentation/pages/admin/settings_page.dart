import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/settings_section.dart';
import '../../controllers/settings_controller.dart';
import '../../theme/app_breakpoints.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';
import 'settings_google_calendar_section.dart';
import 'settings_sidebar.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < AppBreakpoints.mobile;

    return AdminLayout(
      title: Tr.adminSidebarSettings.tr,
      body: isMobile
          ? _MobileSettingsLayout(controller: controller)
          : _DesktopSettingsLayout(controller: controller),
    );
  }
}

class _DesktopSettingsLayout extends StatelessWidget {
  const _DesktopSettingsLayout({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Settings sidebar
        SettingsSidebar(controller: controller),
        // Content area
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return switch (controller.selectedSection.value) {
              SettingsSection.integrations => ListView(
                padding: const EdgeInsets.all(24),
                children: [GoogleCalendarSection(controller: controller)],
              ),
              _ => _PlaceholderPanel(
                title: controller.selectedSection.value.label,
              ),
            };
          }),
        ),
      ],
    );
  }
}

class _MobileSettingsLayout extends StatelessWidget {
  const _MobileSettingsLayout({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section selector
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: SettingsSection.values.map((section) {
                final isActive = controller.selectedSection.value == section;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => controller.selectedSection.value = section,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.terracotta
                            : AppColors.bgCard,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive
                              ? AppColors.terracotta
                              : AppColors.border,
                        ),
                      ),
                      child: Text(
                        section.label,
                        style: AppTypography.bodySmall().copyWith(
                          color: isActive ? Colors.white : AppColors.encre,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const Divider(height: 1, color: AppColors.border),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return switch (controller.selectedSection.value) {
              SettingsSection.integrations => ListView(
                padding: const EdgeInsets.all(24),
                children: [GoogleCalendarSection(controller: controller)],
              ),
              _ => _PlaceholderPanel(
                title: controller.selectedSection.value.label,
              ),
            };
          }),
        ),
      ],
    );
  }
}

class _PlaceholderPanel extends StatelessWidget {
  const _PlaceholderPanel({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.construction_outlined,
            size: 48,
            color: AppColors.pierre.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTypography.heading4()),
          const SizedBox(height: 8),
          Text(Tr.settingsPlaceholder.tr, style: AppTypography.bodySmall()),
        ],
      ),
    );
  }
}
