import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/client.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';
import 'clients_page.dart' show AcquisitionSourceTr;

class ClientDetailPage extends StatelessWidget {
  const ClientDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final client = Get.arguments as Client?;
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
                _DetailSection(
                  title: Tr.adminClientFormSectionIdentity.tr,
                  rows: [
                    _DetailRow(
                      label: Tr.adminClientFormFirstName.tr,
                      value: client.firstName,
                    ),
                    _DetailRow(
                      label: Tr.adminClientFormLastName.tr,
                      value: client.lastName,
                    ),
                    _DetailRow(
                      label: Tr.adminClientFormEmail.tr,
                      value: client.email ?? Tr.adminClientDetailNoEmail.tr,
                    ),
                    _DetailRow(
                      label: Tr.adminClientFormPhone.tr,
                      value: client.phone ?? Tr.adminClientDetailNoPhone.tr,
                    ),
                    if (client.dateOfBirth != null)
                      _DetailRow(
                        label: Tr.adminClientFormDob.tr,
                        value: _formatDate(client.dateOfBirth!),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                _DetailSection(
                  title: Tr.adminClientFormSectionAddress.tr,
                  rows: [
                    _DetailRow(
                      label: Tr.adminClientFormSectionAddress.tr,
                      value:
                          _formatAddress(client) ??
                          Tr.adminClientDetailNoAddress.tr,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _DetailSection(
                  title: Tr.adminClientFormSectionCrm.tr,
                  rows: [
                    if (client.acquisitionSource != null)
                      _DetailRow(
                        label: Tr.adminClientFormAcquisitionSource.tr,
                        value: client.acquisitionSource!.trKey.tr,
                      ),
                    _DetailRow(
                      label: Tr.adminClientFormTags.tr,
                      value: client.tags.isEmpty ? '—' : client.tags.join(', '),
                    ),
                    _DetailRow(
                      label: Tr.adminClientFormNotes.tr,
                      value: client.notes ?? Tr.adminClientDetailNoNotes.tr,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _DetailSection(
                  title: Tr.adminClientFormSectionGdpr.tr,
                  rows: [
                    if (client.gdprConsentDate != null)
                      _DetailRow(
                        label: Tr.adminClientFormGdprConsentDate.tr,
                        value: _formatDate(client.gdprConsentDate!),
                      ),
                    _DetailRow(
                      label: Tr.adminClientFormGdprEmail.tr,
                      value: _boolLabel(
                        client.communicationPrefs?.email ?? false,
                      ),
                    ),
                    _DetailRow(
                      label: Tr.adminClientFormGdprSms.tr,
                      value: _boolLabel(
                        client.communicationPrefs?.sms ?? false,
                      ),
                    ),
                    _DetailRow(
                      label: Tr.adminClientFormGdprPhone.tr,
                      value: _boolLabel(
                        client.communicationPrefs?.phone ?? false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';

  String? _formatAddress(Client client) {
    final a = client.address;
    if (a == null) return null;
    final parts = [
      a.street,
      a.city,
      a.postalCode,
      a.country,
    ].whereType<String>().where((s) => s.isNotEmpty).toList();
    if (parts.isEmpty) return null;
    return parts.join(', ');
  }

  String _boolLabel(bool value) => value ? '✓' : '—';
}

class _DetailActions extends StatelessWidget {
  const _DetailActions({required this.client});

  final Client client;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton.icon(
          onPressed: () => Get.toNamed(
            '/admin/clients/${client.id}/edit',
            arguments: client,
          ),
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
          onPressed: () => _confirmDelete(context),
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

  void _confirmDelete(BuildContext context) {
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
            onPressed: () {
              Navigator.of(ctx).pop();
              Get.back(); // nav back to list; list controller handles deletion
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

class _DetailSection extends StatelessWidget {
  const _DetailSection({required this.title, required this.rows});

  final String title;
  final List<_DetailRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: AppTypography.label()),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: AppTypography.bodySmall().copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.pierre,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTypography.bodyMedium())),
        ],
      ),
    );
  }
}
