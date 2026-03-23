import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/settings_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import 'settings_auth_code_input.dart';

class GoogleCalendarSection extends StatelessWidget {
  const GoogleCalendarSection({super.key, required this.controller});

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
            Tr.admin.settings.googleCalendar.title.tr,
            style: AppTypography.heading3(),
          ),
          const SizedBox(height: 4),
          Text(
            Tr.admin.settings.googleCalendar.desc.tr,
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
                          ? Tr.admin.settings.googleCalendar.connected.tr
                          : Tr.admin.settings.googleCalendar.disconnected.tr,
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
                    label: Tr.admin.settings.googleCalendar.id.tr,
                    value: conn.calendarId,
                  ),
                  if (conn.lastSyncAt != null)
                    _InfoRow(
                      label: Tr.admin.settings.googleCalendar.lastSync.tr,
                      value: _formatDateTime(conn.lastSyncAt!),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        Tr.admin.settings.googleCalendar.syncEnabled.tr,
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
              label: Text(Tr.admin.settings.googleCalendar.connect.tr),
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
                        ? Tr.admin.settings.googleCalendar.syncing.tr
                        : Tr.admin.settings.googleCalendar.syncNow.tr,
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
                  label: Text(Tr.admin.settings.googleCalendar.disconnect.tr),
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
          Tr.admin.settings.googleCalendar.disconnect.tr,
          style: AppTypography.heading4(),
        ),
        content: Text(
          Tr.admin.settings.googleCalendar.disconnectConfirm.tr,
          style: AppTypography.bodySmall(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              Tr.admin.clientForm.cancel.tr,
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
              Tr.admin.settings.googleCalendar.disconnect.tr,
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
