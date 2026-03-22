import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/settings_section.dart';
import '../../controllers/settings_controller.dart';
import '../../theme/app_breakpoints.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';
import 'settings_auth_code_input.dart';

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
        _SettingsSidebar(controller: controller),
        // Content area
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return switch (controller.selectedSection.value) {
              SettingsSection.integrations => ListView(
                padding: const EdgeInsets.all(24),
                children: [_GoogleCalendarSection(controller: controller)],
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
                children: [_GoogleCalendarSection(controller: controller)],
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

class _SettingsSidebar extends StatelessWidget {
  const _SettingsSidebar({required this.controller});

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

class _GoogleCalendarSection extends StatelessWidget {
  const _GoogleCalendarSection({required this.controller});

  final SettingsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final conn = controller.connection.value;
      final isConnected = conn != null;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Tr.settingsGoogleCalendarTitle.tr,
            style: AppTypography.heading3(),
          ),
          const SizedBox(height: 4),
          Text(
            Tr.settingsGoogleCalendarDesc.tr,
            style: AppTypography.bodySmall().copyWith(color: AppColors.pierre),
          ),
          const SizedBox(height: 24),
          if (controller.errorMessage.value != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                controller.errorMessage.value!,
                style: AppTypography.bodySmall().copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          // Status card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isConnected ? Icons.check_circle : Icons.link_off,
                      color: isConnected ? AppColors.success : AppColors.pierre,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isConnected
                          ? Tr.settingsGoogleCalendarConnected.tr
                          : Tr.settingsGoogleCalendarDisconnected.tr,
                      style: AppTypography.bodyMedium().copyWith(
                        fontWeight: FontWeight.w600,
                        color: isConnected
                            ? AppColors.success
                            : AppColors.pierre,
                      ),
                    ),
                  ],
                ),
                if (isConnected) ...[
                  const SizedBox(height: 12),
                  _InfoRow(
                    label: Tr.settingsGoogleCalendarId.tr,
                    value: conn.calendarId,
                  ),
                  if (conn.lastSyncAt != null)
                    _InfoRow(
                      label: Tr.settingsGoogleCalendarLastSync.tr,
                      value: _formatDateTime(conn.lastSyncAt!),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        Tr.settingsGoogleCalendarSyncEnabled.tr,
                        style: AppTypography.bodySmall(),
                      ),
                      const Spacer(),
                      Switch(
                        value: conn.syncEnabled,
                        onChanged: (v) => controller.toggleSync(enabled: v),
                        activeThumbColor: AppColors.terracotta,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Actions
          if (!isConnected)
            FilledButton.icon(
              onPressed: () => controller.connectGoogle(),
              icon: const Icon(Icons.calendar_today, size: 18),
              label: Text(Tr.settingsGoogleCalendarConnect.tr),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.crepuscule,
                foregroundColor: Colors.white,
                textStyle: AppTypography.button(),
              ),
            )
          else
            Row(
              children: [
                // Manual sync
                OutlinedButton.icon(
                  onPressed: controller.isSyncing.value
                      ? null
                      : controller.manualSync,
                  icon: controller.isSyncing.value
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.sync, size: 16),
                  label: Text(
                    controller.isSyncing.value
                        ? Tr.settingsGoogleCalendarSyncing.tr
                        : Tr.settingsGoogleCalendarSyncNow.tr,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.crepuscule,
                    textStyle: AppTypography.button(),
                  ),
                ),
                const SizedBox(width: 12),
                // Disconnect
                OutlinedButton.icon(
                  onPressed: () => _confirmDisconnect(context),
                  icon: const Icon(Icons.link_off, size: 16),
                  label: Text(Tr.settingsGoogleCalendarDisconnect.tr),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    textStyle: AppTypography.button(),
                  ),
                ),
              ],
            ),
          // Pending auth URL
          if (controller.pendingAuthUrl.value != null)
            SettingsAuthCodeInput(
              authUrl: controller.pendingAuthUrl.value!,
              onSubmit: controller.submitAuthCode,
              onCancel: () => controller.pendingAuthUrl.value = null,
            ),
        ],
      );
    });
  }

  void _confirmDisconnect(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          Tr.settingsGoogleCalendarDisconnect.tr,
          style: AppTypography.heading4(),
        ),
        content: Text(
          Tr.settingsGoogleCalendarDisconnectConfirm.tr,
          style: AppTypography.bodySmall(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              Tr.adminClientFormCancel.tr,
              style: AppTypography.button().copyWith(color: AppColors.pierre),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              controller.disconnectGoogle();
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(
              Tr.settingsGoogleCalendarDisconnect.tr,
              style: AppTypography.button(),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final d =
        '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final t =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$d $t';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: AppTypography.bodySmall().copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTypography.bodySmall())),
        ],
      ),
    );
  }
}
