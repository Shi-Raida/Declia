import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/acquisition_source.dart';
import '../../../core/enums/client_sort_field.dart';
import '../../../core/enums/client_status.dart';
import '../../../core/enums/session_type.dart';
import '../../../core/enums/sort_direction.dart';
import '../../controllers/clients_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/styled_dropdown.dart';
import 'acquisition_source_tr.dart';
import 'clients_tag_filter_row.dart';
import 'history_enum_extensions.dart';

class ClientsFilterBar extends StatefulWidget {
  const ClientsFilterBar({required this.controller, super.key});

  final ClientsController controller;

  @override
  State<ClientsFilterBar> createState() => _ClientsFilterBarState();
}

class _ClientsFilterBarState extends State<ClientsFilterBar> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ctrl = widget.controller;
      final q = ctrl.query.value;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Search input
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      onChanged: (v) => ctrl.searchQuery.value = v,
                      decoration: InputDecoration(
                        hintText: Tr.admin.clients.search.tr,
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
                // Status dropdown
                StyledDropdown<ClientStatus?>(
                  value: q.statusFilter,
                  hint: Tr.admin.clients.allStatuses.tr,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(Tr.admin.clients.allStatuses.tr),
                    ),
                    ...ClientStatus.values.map(
                      (s) => DropdownMenuItem(value: s, child: Text(s.label)),
                    ),
                  ],
                  onChanged: ctrl.setStatusFilter,
                ),
                const SizedBox(width: 12),
                // Session type dropdown
                StyledDropdown<SessionType?>(
                  value: q.sessionTypeFilter,
                  hint: Tr.admin.clients.allCategories.tr,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(Tr.admin.clients.allCategories.tr),
                    ),
                    ...SessionType.values.map(
                      (t) =>
                          DropdownMenuItem(value: t, child: Text(t.trKey.tr)),
                    ),
                  ],
                  onChanged: ctrl.setSessionTypeFilter,
                ),
                const SizedBox(width: 12),
                // Source dropdown
                StyledDropdown<AcquisitionSource?>(
                  value: q.acquisitionSource,
                  hint: Tr.admin.clients.filterBySource.tr,
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(Tr.admin.clients.allSources.tr),
                    ),
                    ...AcquisitionSource.values.map(
                      (src) => DropdownMenuItem(
                        value: src,
                        child: Text(src.trKey.tr),
                      ),
                    ),
                  ],
                  onChanged: ctrl.setAcquisitionSourceFilter,
                ),
                const SizedBox(width: 12),
                // Sort dropdown
                StyledDropdown<ClientSortField>(
                  value: q.sortField,
                  hint: Tr.admin.clients.sortBy.tr,
                  items: [
                    DropdownMenuItem(
                      value: ClientSortField.name,
                      child: Text(Tr.admin.clients.sortName.tr),
                    ),
                    DropdownMenuItem(
                      value: ClientSortField.createdAt,
                      child: Text(Tr.admin.clients.sortDate.tr),
                    ),
                  ],
                  onChanged: (field) {
                    if (field != null) ctrl.toggleSort(field);
                  },
                ),
                // Sort direction toggle
                IconButton(
                  icon: Icon(
                    q.sortDirection == SortDirection.ascending
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 16,
                  ),
                  color: AppColors.pierre,
                  tooltip: q.sortDirection == SortDirection.ascending
                      ? 'Ascending'
                      : 'Descending',
                  onPressed: () => ctrl.toggleSort(q.sortField),
                ),
                const SizedBox(width: 8),
                // Count + clear
                Text(
                  Tr.admin.clients.count.trParams({
                    'count': '${ctrl.totalCount.value}',
                  }),
                  style: AppTypography.bodySmall(),
                ),
                if (ctrl.hasActiveFilters) ...[
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: ctrl.clearFilters,
                    icon: const Icon(Icons.filter_alt_off, size: 16),
                    label: Text(
                      Tr.admin.clients.clearFilters.tr,
                      style: AppTypography.bodySmall(),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.error,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 32),
                    ),
                  ),
                ],
              ],
            ),
            // Active filter chips row
            if (q.statusFilter != null || q.sessionTypeFilter != null) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  if (q.statusFilter != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InputChip(
                        label: Text(
                          q.statusFilter!.label,
                          style: AppTypography.bodySmall().copyWith(
                            color: AppColors.bleuOuvert,
                          ),
                        ),
                        onDeleted: () => ctrl.setStatusFilter(null),
                        backgroundColor: AppColors.bleuOuvertLight,
                        deleteIconColor: AppColors.bleuOuvert,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  if (q.sessionTypeFilter != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: InputChip(
                        label: Text(
                          q.sessionTypeFilter!.trKey.tr,
                          style: AppTypography.bodySmall().copyWith(
                            color: AppColors.bleuOuvert,
                          ),
                        ),
                        onDeleted: () => ctrl.setSessionTypeFilter(null),
                        backgroundColor: AppColors.bleuOuvertLight,
                        deleteIconColor: AppColors.bleuOuvert,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                ],
              ),
            ],
            // Tag filter row
            if (ctrl.availableTags.isNotEmpty || q.tags.isNotEmpty) ...[
              const SizedBox(height: 10),
              ClientsTagFilterRow(controller: ctrl, query: q),
            ],
          ],
        ),
      );
    });
  }
}
