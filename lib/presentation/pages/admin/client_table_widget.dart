import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/client_sort_field.dart';
import '../../../core/enums/client_status.dart';
import '../../../core/enums/sort_direction.dart';
import '../../controllers/clients_controller.dart';
import '../../models/client_view_model.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/session_type_tag.dart';
import '../../widgets/admin/status_badge.dart';
import '../../widgets/admin/user_avatar.dart';
import 'history_enum_extensions.dart';
import 'client_status_color.dart';
import 'session_type_color.dart';

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
        return Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: DataTable(
            sortColumnIndex: sortField == ClientSortField.name ? 1 : null,
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
            border: const TableBorder(
              horizontalInside: BorderSide(color: AppColors.border),
            ),
            columns: [
              // Checkbox column
              DataColumn(
                label: Obx(
                  () => Checkbox(
                    value: controller.isAllSelected,
                    onChanged: (_) => controller.toggleSelectAll(),
                    activeColor: AppColors.bleuOuvert,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
              DataColumn(
                label: Text(Tr.adminClientsTableName.tr),
                onSort: (_, ascending) => controller.setSort(
                  ClientSortField.name,
                  ascending
                      ? SortDirection.ascending
                      : SortDirection.descending,
                ),
              ),
              DataColumn(label: Text(Tr.adminClientsTablePhone.tr)),
              DataColumn(label: Text(Tr.adminClientsTableCategory.tr)),
              DataColumn(label: Text(Tr.adminClientsTableStatus.tr)),
              DataColumn(label: Text(Tr.adminClientsTableLastShooting.tr)),
              DataColumn(label: Text(Tr.adminClientsTableRevenue.tr)),
              DataColumn(label: Text(Tr.adminClientsTableActions.tr)),
            ],
            rows: controller.clients
                .map((vm) => _buildRow(context, vm))
                .toList(),
          ),
        );
      }),
    );
  }

  String _getInitials(ClientViewModel vm) {
    final first = vm.firstName.isNotEmpty ? vm.firstName[0].toUpperCase() : '';
    final last = vm.lastName.isNotEmpty ? vm.lastName[0].toUpperCase() : '';
    return '$first$last';
  }

  DataRow _buildRow(BuildContext context, ClientViewModel vm) {
    return DataRow(
      cells: [
        // Checkbox
        DataCell(
          Obx(
            () => Checkbox(
              value: controller.selectedIds.contains(vm.id),
              onChanged: (_) => controller.toggleSelect(vm.id),
              activeColor: AppColors.bleuOuvert,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
        ),
        // Combined name + email + avatar
        DataCell(
          GestureDetector(
            onTap: () => controller.viewClient(vm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                UserAvatar(initials: _getInitials(vm), size: 36),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${vm.firstName} ${vm.lastName}',
                      style: AppTypography.bodyMedium().copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (vm.email != null)
                      Text(vm.email!, style: AppTypography.bodySmall()),
                  ],
                ),
              ],
            ),
          ),
        ),
        DataCell(Text(vm.phone ?? '—')),
        // Category column
        DataCell(
          vm.sessionTypes.isEmpty
              ? Text('—', style: AppTypography.bodySmall())
              : Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: vm.sessionTypes
                      .take(2)
                      .map(
                        (t) =>
                            SessionTypeTag(label: t.trKey.tr, color: t.color),
                      )
                      .toList(),
                ),
        ),
        // Status
        DataCell(
          StatusBadge(
            text: vm.clientStatus.label,
            color: vm.clientStatus.color,
          ),
        ),
        DataCell(
          Text(vm.lastShootingDisplay, style: AppTypography.bodySmall()),
        ),
        DataCell(Text(vm.totalSpentDisplay, style: AppTypography.bodySmall())),
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
