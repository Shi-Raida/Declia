import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/client_detail_controller.dart';
import '../../models/client_view_model.dart';
import '../../theme/app_colors.dart';
import '../../utils/date_formatter.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';
import '../../widgets/admin/detail_section.dart';
import 'client_detail_communications_section.dart';
import 'client_detail_galleries_section.dart';
import 'client_detail_orders_section.dart';
import 'client_detail_sessions_section.dart';
import 'client_detail_stats_card.dart';
import 'clients_filter_bar.dart' show AcquisitionSourceTr;

class ClientDetailPage extends GetView<ClientDetailController> {
  const ClientDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final client = controller.client.value;
      if (client == null) {
        return const AdminLayout(
          title: '',
          body: Center(child: CircularProgressIndicator()),
        );
      }

      return AdminLayout(
        title: '${client.firstName} ${client.lastName}',
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _DetailActions(client: client),
                  const SizedBox(height: 20),
                  // Stats summary
                  Obx(() {
                    final h = controller.history.value;
                    if (h != null) {
                      return Column(
                        children: [
                          ClientDetailStatsCard(history: h),
                          const SizedBox(height: 16),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  // Identity
                  DetailSection(
                    title: Tr.adminClientFormSectionIdentity.tr,
                    rows: [
                      DetailRow(
                        label: Tr.adminClientFormFirstName.tr,
                        value: client.firstName,
                      ),
                      DetailRow(
                        label: Tr.adminClientFormLastName.tr,
                        value: client.lastName,
                      ),
                      DetailRow(
                        label: Tr.adminClientFormEmail.tr,
                        value: client.email ?? Tr.adminClientDetailNoEmail.tr,
                      ),
                      DetailRow(
                        label: Tr.adminClientFormPhone.tr,
                        value: client.phone ?? Tr.adminClientDetailNoPhone.tr,
                      ),
                      if (client.dateOfBirth != null)
                        DetailRow(
                          label: Tr.adminClientFormDob.tr,
                          value: formatDate(client.dateOfBirth!),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Address
                  DetailSection(
                    title: Tr.adminClientFormSectionAddress.tr,
                    rows: [
                      DetailRow(
                        label: Tr.adminClientFormSectionAddress.tr,
                        value:
                            _formatAddress(client) ??
                            Tr.adminClientDetailNoAddress.tr,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // CRM
                  DetailSection(
                    title: Tr.adminClientFormSectionCrm.tr,
                    rows: [
                      if (client.acquisitionSource != null)
                        DetailRow(
                          label: Tr.adminClientFormAcquisitionSource.tr,
                          value: client.acquisitionSource!.trKey.tr,
                        ),
                      DetailRow(
                        label: Tr.adminClientFormTags.tr,
                        value: client.tags.isEmpty
                            ? '—'
                            : client.tags.join(', '),
                      ),
                      DetailRow(
                        label: Tr.adminClientFormNotes.tr,
                        value: client.notes ?? Tr.adminClientDetailNoNotes.tr,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // GDPR
                  DetailSection(
                    title: Tr.adminClientFormSectionGdpr.tr,
                    rows: [
                      if (client.gdprConsentDate != null)
                        DetailRow(
                          label: Tr.adminClientFormGdprConsentDate.tr,
                          value: formatDate(client.gdprConsentDate!),
                        ),
                      DetailRow(
                        label: Tr.adminClientFormGdprEmail.tr,
                        value: _boolLabel(client.commEmail),
                      ),
                      DetailRow(
                        label: Tr.adminClientFormGdprSms.tr,
                        value: _boolLabel(client.commSms),
                      ),
                      DetailRow(
                        label: Tr.adminClientFormGdprPhone.tr,
                        value: _boolLabel(client.commPhone),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // History sections
                  Obx(() {
                    final h = controller.history.value;
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (h == null) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClientDetailSessionsSection(sessions: h.sessions),
                        const SizedBox(height: 16),
                        ClientDetailGalleriesSection(galleries: h.galleries),
                        const SizedBox(height: 16),
                        ClientDetailOrdersSection(orders: h.orders),
                        const SizedBox(height: 16),
                        ClientDetailCommunicationsSection(
                          communicationLogs: h.communicationLogs,
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  String? _formatAddress(ClientViewModel vm) {
    final parts = [
      vm.street,
      vm.city,
      vm.postalCode,
      vm.country,
    ].whereType<String>().where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  String _boolLabel(bool value) => value ? '✓' : '—';
}

class _DetailActions extends StatelessWidget {
  const _DetailActions({required this.client});

  final ClientViewModel client;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientDetailController>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton.icon(
          onPressed: controller.editClient,
          icon: const Icon(Icons.edit_outlined, size: 16),
          label: Text(Tr.adminClientDetailEdit.tr),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.crepuscule,
            side: const BorderSide(color: AppColors.border),
            textStyle: AppTypography.button(),
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () => _confirmDelete(context, controller),
          icon: const Icon(Icons.delete_outline, size: 16),
          label: Text(Tr.adminClientDetailDelete.tr),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.error,
            side: const BorderSide(color: AppColors.error),
            textStyle: AppTypography.button(),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, ClientDetailController controller) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          Tr.adminClientsDeleteConfirm.tr,
          style: AppTypography.heading4(),
        ),
        content: Text(
          Tr.adminClientsDeleteBody.tr,
          style: AppTypography.bodyMedium(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              Tr.adminClientFormCancel.tr,
              style: AppTypography.button().copyWith(color: AppColors.pierre),
            ),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await controller.deleteClient();
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: Text(
              Tr.adminClientDetailDelete.tr,
              style: AppTypography.button(),
            ),
          ),
        ],
      ),
    );
  }
}
