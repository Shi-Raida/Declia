import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/settings_section.dart';
import '../../controllers/settings_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class SettingsSidebar extends StatelessWidget {
  const SettingsSidebar({super.key, required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _SettingsSidebarSection(
            title: Tr.settingsSectionMyStudio.tr,
            items: [
              _SettingsSidebarItem(
                label: Tr.settingsSectionStudio.tr,
                icon: Icons.store_outlined,
                section: SettingsSection.studio,
                controller: controller,
              ),
              _SettingsSidebarItem(
                label: Tr.settingsSectionLegal.tr,
                icon: Icons.gavel_outlined,
                section: SettingsSection.legal,
                controller: controller,
              ),
            ],
          ),
          _SettingsSidebarSection(
            title: Tr.settingsSectionIdentity.tr,
            items: [
              _SettingsSidebarItem(
                label: Tr.settingsSectionColors.tr,
                icon: Icons.palette_outlined,
                section: SettingsSection.colors,
                controller: controller,
              ),
              _SettingsSidebarItem(
                label: Tr.settingsSectionTypography.tr,
                icon: Icons.text_fields_outlined,
                section: SettingsSection.typography,
                controller: controller,
              ),
            ],
          ),
          _SettingsSidebarSection(
            title: Tr.settingsSectionConnections.tr,
            items: [
              _SettingsSidebarItem(
                label: Tr.settingsSectionIntegrations.tr,
                icon: Icons.extension_outlined,
                section: SettingsSection.integrations,
                controller: controller,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SettingsSidebarSection extends StatelessWidget {
  const _SettingsSidebarSection({required this.title, required this.items});

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Text(title, style: AppTypography.sectionTitle()),
        ),
        ...items,
        const SizedBox(height: 8),
      ],
    );
  }
}

class _SettingsSidebarItem extends StatelessWidget {
  const _SettingsSidebarItem({
    required this.label,
    required this.icon,
    required this.section,
    required this.controller,
  });

  final String label;
  final IconData icon;
  final SettingsSection section;
  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isActive = controller.selectedSection.value == section;
      return InkWell(
        onTap: () => controller.selectedSection.value = section,
        child: Container(
          height: 42,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.terracotta.withValues(alpha: 0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive ? AppColors.terracotta : AppColors.pierre,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? AppColors.terracotta : AppColors.encre,
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
