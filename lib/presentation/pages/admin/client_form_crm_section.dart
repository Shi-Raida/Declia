import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/acquisition_source.dart';
import '../../controllers/client_form_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import 'client_form_shared_widgets.dart';
import 'clients_page.dart' show AcquisitionSourceTr;

class ClientFormCrmSection extends StatelessWidget {
  const ClientFormCrmSection({super.key, required this.controller});

  final ClientFormController controller;

  @override
  Widget build(BuildContext context) {
    return ClientFormSectionCard(
      title: Tr.adminClientFormSectionCrm.tr,
      children: [
        _AcquisitionSourceField(controller: controller),
        _TagsField(controller: controller),
        ClientFormTextField(
          label: Tr.adminClientFormNotes.tr,
          controller: controller.notesCtrl,
          maxLines: 4,
        ),
      ],
    );
  }
}

class _AcquisitionSourceField extends StatelessWidget {
  const _AcquisitionSourceField({required this.controller});

  final ClientFormController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Tr.adminClientFormAcquisitionSource.tr,
            style: AppTypography.bodySmall().copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.encre,
            ),
          ),
          const SizedBox(height: 4),
          DropdownButtonFormField<AcquisitionSource>(
            initialValue: controller.acquisitionSource.value,
            onChanged: (v) => controller.acquisitionSource.value = v,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.bg,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                  color: AppColors.terracotta,
                  width: 1.5,
                ),
              ),
            ),
            items: AcquisitionSource.values
                .map(
                  (s) => DropdownMenuItem(
                    value: s,
                    child: Text(s.trKey.tr, style: AppTypography.bodyMedium()),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _TagsField extends StatelessWidget {
  const _TagsField({required this.controller});

  final ClientFormController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Tr.adminClientFormTags.tr,
          style: AppTypography.bodySmall().copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.encre,
          ),
        ),
        const SizedBox(height: 4),
        Obx(
          () => Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              ...controller.tags.map(
                (tag) => Chip(
                  label: Text(tag, style: AppTypography.bodySmall()),
                  backgroundColor: AppColors.terracottaLight,
                  deleteIconColor: AppColors.terracotta,
                  onDeleted: () => controller.removeTag(tag),
                  visualDensity: VisualDensity.compact,
                ),
              ),
              SizedBox(
                width: 160,
                child: Autocomplete<String>(
                  optionsBuilder: (textEditingValue) {
                    final input = textEditingValue.text.toLowerCase();
                    if (input.isEmpty) return const [];
                    return controller.availableTags.where(
                      (tag) =>
                          tag.toLowerCase().contains(input) &&
                          !controller.tags.contains(tag),
                    );
                  },
                  onSelected: controller.addTag,
                  fieldViewBuilder: (
                    context,
                    textController,
                    focusNode,
                    onFieldSubmitted,
                  ) {
                    return TextField(
                      controller: textController,
                      focusNode: focusNode,
                      style: AppTypography.bodyMedium(),
                      decoration: InputDecoration(
                        hintText: '+ tag',
                        hintStyle: AppTypography.bodySmall(),
                        filled: true,
                        fillColor: AppColors.bg,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                          borderSide: const BorderSide(
                            color: AppColors.terracotta,
                            width: 1.5,
                          ),
                        ),
                        isDense: true,
                      ),
                      onSubmitted: (value) {
                        controller.addTag(value);
                        textController.clear();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
