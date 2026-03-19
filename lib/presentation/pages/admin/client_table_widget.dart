import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/clients_controller.dart';
import '../../models/client_view_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class ClientsTable extends StatelessWidget {
  const ClientsTable({super.key, required this.controller});

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
          rows: controller.clients.map((vm) => _buildRow(context, vm)).toList(),
        ),
      ),
    );
  }

  DataRow _buildRow(BuildContext context, ClientViewModel vm) {
    return DataRow(
      cells: [
        DataCell(
          GestureDetector(
            onTap: () => Get.toNamed('/admin/clients/${vm.id}', arguments: vm),
            child: Text(
              '${vm.lastName} ${vm.firstName}',
              style: AppTypography.bodyMedium().copyWith(
                color: AppColors.terracotta,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        DataCell(Text(vm.email ?? '—')),
        DataCell(Text(vm.phone ?? '—')),
        DataCell(_TagsCell(tags: vm.tags)),
        DataCell(
          Text(_formatDate(vm.createdAt), style: AppTypography.bodySmall()),
        ),
        DataCell(_ActionsCell(vm: vm, controller: controller)),
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
  const _ActionsCell({required this.vm, required this.controller});

  final ClientViewModel vm;
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
          onPressed: () =>
              Get.toNamed('/admin/clients/${vm.id}', arguments: vm),
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 18),
          color: AppColors.pierre,
          tooltip: Tr.adminClientDetailEdit.tr,
          onPressed: () =>
              Get.toNamed('/admin/clients/${vm.id}/edit', arguments: vm),
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
              style: AppTypography.button().copyWith(color: AppColors.pierre),
            ),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await controller.removeClient(vm.id);
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
