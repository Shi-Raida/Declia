import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/client_sort_field.dart';
import '../../../core/enums/sort_direction.dart';
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
      child: Obx(() {
        final sortField = controller.query.value.sortField;
        final sortAsc =
            controller.query.value.sortDirection == SortDirection.ascending;
        return DataTable(
          sortColumnIndex: sortField == ClientSortField.name ? 0 : null,
          sortAscending: sortAsc,
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
            DataColumn(
              label: Text(Tr.adminClientsTableName.tr),
              onSort: (_, ascending) => controller.setSort(
                ClientSortField.name,
                ascending ? SortDirection.ascending : SortDirection.descending,
              ),
            ),
            DataColumn(label: Text(Tr.adminClientsTableEmail.tr)),
            DataColumn(label: Text(Tr.adminClientsTablePhone.tr)),
            DataColumn(label: Text(Tr.adminClientsTableSessions.tr)),
            DataColumn(label: Text(Tr.adminClientsTableTotalSpent.tr)),
            DataColumn(label: Text(Tr.adminClientsTableLastShooting.tr)),
            DataColumn(label: Text(Tr.adminClientsTableActions.tr)),
          ],
          rows: controller.clients.map((vm) => _buildRow(context, vm)).toList(),
        );
      }),
    );
  }

  DataRow _buildRow(BuildContext context, ClientViewModel vm) {
    return DataRow(
      cells: [
        DataCell(
          GestureDetector(
            onTap: () => controller.viewClient(vm),
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
        DataCell(
          Text(vm.sessionCountDisplay, style: AppTypography.bodySmall()),
        ),
        DataCell(Text(vm.totalSpentDisplay, style: AppTypography.bodySmall())),
        DataCell(
          Text(vm.lastShootingDisplay, style: AppTypography.bodySmall()),
        ),
        DataCell(_ActionsCell(vm: vm, controller: controller)),
      ],
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
          tooltip: Tr.adminClientDetailView.tr,
          onPressed: () => controller.viewClient(vm),
        ),
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 18),
          color: AppColors.pierre,
          tooltip: Tr.adminClientDetailEdit.tr,
          onPressed: () => controller.editClient(vm),
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
