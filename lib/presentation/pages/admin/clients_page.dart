import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/acquisition_source.dart';
import '../../../domain/entities/client.dart';
import '../../controllers/clients_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';

class ClientsPage extends GetView<ClientsController> {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: Tr.adminClientsTitle.tr,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ClientsToolbar(controller: controller),
          Expanded(child: _ClientsContent(controller: controller)),
        ],
      ),
    );
  }
}

class _ClientsToolbar extends StatelessWidget {
  const _ClientsToolbar({required this.controller});

  final ClientsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                onChanged: (v) => controller.searchQuery.value = v,
                decoration: InputDecoration(
                  hintText: Tr.adminClientsSearch.tr,
                  hintStyle: AppTypography.bodySmall(),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 18,
                    color: AppColors.pierre,
                  ),
                  filled: true,
                  fillColor: AppColors.bg,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.terracotta,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: () => Get.toNamed(AppRoutes.adminClientNew),
            icon: const Icon(Icons.add, size: 18),
            label: Text(Tr.adminClientsNew.tr),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.terracotta,
              foregroundColor: Colors.white,
              textStyle: AppTypography.button(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              minimumSize: const Size(0, 40),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientsContent extends StatelessWidget {
  const _ClientsContent({required this.controller});

  final ClientsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.errorMessage.value != null) {
        return Center(
          child: Text(
            controller.errorMessage.value!,
            style: AppTypography.bodyMedium().copyWith(color: AppColors.error),
          ),
        );
      }
      if (controller.clients.isEmpty) {
        return Center(
          child: Text(
            Tr.adminClientsEmpty.tr,
            style:
                AppTypography.bodyMedium().copyWith(color: AppColors.pierre),
          ),
        );
      }
      return _ClientsTable(controller: controller);
    });
  }
}

class _ClientsTable extends StatelessWidget {
  const _ClientsTable({required this.controller});

  final ClientsController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Obx(
        () => DataTable(
          headingRowColor: WidgetStateProperty.all(AppColors.bgAlt),
          headingTextStyle: AppTypography.bodySmall().copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.pierre,
            letterSpacing: 0.8,
          ),
          dataTextStyle: AppTypography.bodyMedium(),
          columnSpacing: 20,
          dividerThickness: 1,
          border: TableBorder.all(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(8),
          ),
          columns: [
            DataColumn(label: Text(Tr.adminClientsTableName.tr)),
            DataColumn(label: Text(Tr.adminClientsTableEmail.tr)),
            DataColumn(label: Text(Tr.adminClientsTablePhone.tr)),
            DataColumn(label: Text(Tr.adminClientsTableTags.tr)),
            DataColumn(label: Text(Tr.adminClientsTableDate.tr)),
            DataColumn(label: Text(Tr.adminClientsTableActions.tr)),
          ],
          rows: controller.clients
              .map((client) => _buildRow(context, client))
              .toList(),
        ),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, Client client) {
    return DataRow(
      cells: [
        DataCell(
          GestureDetector(
            onTap: () => Get.toNamed(
              '/admin/clients/${client.id}',
              arguments: client,
            ),
            child: Text(
              '${client.lastName} ${client.firstName}',
              style: AppTypography.bodyMedium().copyWith(
                color: AppColors.terracotta,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        DataCell(Text(client.email ?? '—')),
        DataCell(Text(client.phone ?? '—')),
        DataCell(_TagsCell(tags: client.tags)),
        DataCell(
          Text(
            _formatDate(client.createdAt),
            style: AppTypography.bodySmall(),
          ),
        ),
        DataCell(
          _ActionsCell(client: client, controller: controller),
        ),
      ],
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';
}

class _TagsCell extends StatelessWidget {
  const _TagsCell({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    if (tags.isEmpty) return const Text('—');
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: tags
          .take(3)
          .map(
            (tag) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.terracottaLight,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(tag, style: AppTypography.bodySmall()),
            ),
          )
          .toList(),
    );
  }
}

class _ActionsCell extends StatelessWidget {
  const _ActionsCell({required this.client, required this.controller});

  final Client client;
  final ClientsController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.visibility_outlined, size: 18),
          color: AppColors.bleuOuvert,
          tooltip: 'Voir',
          onPressed: () => Get.toNamed(
            '/admin/clients/${client.id}',
            arguments: client,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 18),
          color: AppColors.pierre,
          tooltip: Tr.adminClientDetailEdit.tr,
          onPressed: () => Get.toNamed(
            '/admin/clients/${client.id}/edit',
            arguments: client,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, size: 18),
          color: AppColors.error,
          tooltip: Tr.adminClientDetailDelete.tr,
          onPressed: () => _confirmDelete(context),
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
              style:
                  AppTypography.button().copyWith(color: AppColors.pierre),
            ),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await controller.removeClient(client.id);
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

/// Translates [AcquisitionSource] to its localisation key.
extension AcquisitionSourceTr on AcquisitionSource {
  String get trKey => switch (this) {
    AcquisitionSource.referral => Tr.acquisitionSourceReferral,
    AcquisitionSource.socialMedia => Tr.acquisitionSourceSocialMedia,
    AcquisitionSource.website => Tr.acquisitionSourceWebsite,
    AcquisitionSource.wordOfMouth => Tr.acquisitionSourceWordOfMouth,
    AcquisitionSource.event => Tr.acquisitionSourceEvent,
    AcquisitionSource.other => Tr.acquisitionSourceOther,
  };
}
