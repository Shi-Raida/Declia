import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/acquisition_source.dart';
import '../../../core/enums/client_sort_field.dart';
import '../../../core/enums/sort_direction.dart';
import '../../controllers/clients_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

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
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
        decoration: const BoxDecoration(
          color: AppColors.bgAlt,
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _label(Tr.adminClientsFilterBySource.tr),
                const SizedBox(width: 8),
                DropdownButton<AcquisitionSource?>(
                  value: q.acquisitionSource,
                  underline: const SizedBox(),
                  style: AppTypography.bodySmall().copyWith(
                    color: AppColors.encre,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: null,
                      child: Text(Tr.adminClientsAllSources.tr),
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
                const SizedBox(width: 20),
                _label(Tr.adminClientsSortBy.tr),
                const SizedBox(width: 8),
                DropdownButton<ClientSortField>(
                  value: q.sortField,
                  underline: const SizedBox(),
                  style: AppTypography.bodySmall().copyWith(
                    color: AppColors.encre,
                  ),
                  items: [
                    DropdownMenuItem(
                      value: ClientSortField.name,
                      child: Text(Tr.adminClientsSortName.tr),
                    ),
                    DropdownMenuItem(
                      value: ClientSortField.createdAt,
                      child: Text(Tr.adminClientsSortDate.tr),
                    ),
                  ],
                  onChanged: (field) {
                    if (field != null) ctrl.toggleSort(field);
                  },
                ),
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
                const Spacer(),
                Text(
                  Tr.adminClientsCount.trParams({
                    'count': '${ctrl.totalCount.value}',
                  }),
                  style: AppTypography.bodySmall().copyWith(
                    color: AppColors.pierre,
                  ),
                ),
                if (ctrl.hasActiveFilters) ...[
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: ctrl.clearFilters,
                    icon: const Icon(Icons.filter_alt_off, size: 16),
                    label: Text(
                      Tr.adminClientsClearFilters.tr,
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
            const SizedBox(height: 6),
            Row(
              children: [
                _label(Tr.adminClientsFilterByTag.tr),
                const SizedBox(width: 8),
                SizedBox(
                  width: 160,
                  height: 32,
                  child: Autocomplete<String>(
                    optionsBuilder: (textEditingValue) {
                      final input = textEditingValue.text.toLowerCase();
                      if (input.isEmpty) return const [];
                      return ctrl.availableTags.where(
                        (tag) =>
                            tag.toLowerCase().contains(input) &&
                            !q.tags.contains(tag),
                      );
                    },
                    onSelected: (tag) => ctrl.addTag(tag),
                    fieldViewBuilder:
                        (context, textController, focusNode, onFieldSubmitted) {
                          return TextField(
                            controller: textController,
                            focusNode: focusNode,
                            style: AppTypography.bodySmall(),
                            decoration: InputDecoration(
                              hintText: Tr.adminClientsFilterTagHint.tr,
                              hintStyle: AppTypography.bodySmall(),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  color: AppColors.border,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: const BorderSide(
                                  color: AppColors.terracotta,
                                ),
                              ),
                            ),
                            onSubmitted: (value) {
                              final tag = value.trim();
                              if (tag.isNotEmpty) {
                                ctrl.addTag(tag);
                                textController.clear();
                              }
                            },
                          );
                        },
                  ),
                ),
                const SizedBox(width: 4),
                ...q.tags.map(
                  (tag) => Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: InputChip(
                      label: Text(tag, style: AppTypography.bodySmall()),
                      onDeleted: () => ctrl.removeTag(tag),
                      backgroundColor: AppColors.terracottaLight,
                      deleteIconColor: AppColors.pierre,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _label(String text) => Text(
    text,
    style: AppTypography.bodySmall().copyWith(color: AppColors.pierre),
  );
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
