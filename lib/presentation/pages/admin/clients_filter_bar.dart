import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/client_status.dart';
import '../../../core/enums/session_type.dart';
import '../../controllers/clients_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/styled_dropdown.dart';
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
        child: Row(
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
            // Active filter chips inline
            if (q.statusFilter != null) ...[
              const SizedBox(width: 8),
              InputChip(
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
            ],
            if (q.sessionTypeFilter != null) ...[
              const SizedBox(width: 8),
              InputChip(
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
            ],
          ],
        ),
      );
    });
  }
}
