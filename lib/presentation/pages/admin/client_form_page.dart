import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/acquisition_source.dart';
import '../../controllers/client_form_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';
import 'clients_page.dart' show AcquisitionSourceTr;

class ClientFormPage extends GetView<ClientFormController> {
  const ClientFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AdminLayout(
        title: controller.isEditing
            ? Tr.adminClientFormTitleEdit.tr
            : Tr.adminClientFormTitleCreate.tr,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SectionCard(
                    title: Tr.adminClientFormSectionIdentity.tr,
                    children: [
                      _FormRow(children: [
                        _FormField(
                          label: Tr.adminClientFormFirstName.tr,
                          controller: controller.firstNameCtrl,
                          required: true,
                        ),
                        _FormField(
                          label: Tr.adminClientFormLastName.tr,
                          controller: controller.lastNameCtrl,
                          required: true,
                        ),
                      ]),
                      _FormRow(children: [
                        _FormField(
                          label: Tr.adminClientFormEmail.tr,
                          controller: controller.emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _FormField(
                          label: Tr.adminClientFormPhone.tr,
                          controller: controller.phoneCtrl,
                          keyboardType: TextInputType.phone,
                        ),
                      ]),
                      _DobField(controller: controller),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: Tr.adminClientFormSectionAddress.tr,
                    children: [
                      _FormField(
                        label: Tr.adminClientFormStreet.tr,
                        controller: controller.streetCtrl,
                      ),
                      _FormRow(children: [
                        _FormField(
                          label: Tr.adminClientFormCity.tr,
                          controller: controller.cityCtrl,
                        ),
                        _FormField(
                          label: Tr.adminClientFormPostalCode.tr,
                          controller: controller.postalCodeCtrl,
                        ),
                      ]),
                      _FormField(
                        label: Tr.adminClientFormCountry.tr,
                        controller: controller.countryCtrl,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: Tr.adminClientFormSectionCrm.tr,
                    children: [
                      _AcquisitionSourceField(controller: controller),
                      _TagsField(controller: controller),
                      _FormField(
                        label: Tr.adminClientFormNotes.tr,
                        controller: controller.notesCtrl,
                        maxLines: 4,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _SectionCard(
                    title: Tr.adminClientFormSectionGdpr.tr,
                    children: [
                      _GdprSection(controller: controller),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (controller.errorMessage.value != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        controller.errorMessage.value!,
                        style: AppTypography.bodySmall().copyWith(
                          color: AppColors.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  _FormActions(controller: controller),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

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
          Text(
            title.toUpperCase(),
            style: AppTypography.label(),
          ),
          const SizedBox(height: 16),
          ...children.map(
            (child) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _FormRow extends StatelessWidget {
  const _FormRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children
          .expand(
            (child) => [
              Expanded(child: child),
              const SizedBox(width: 12),
            ],
          )
          .toList()
        ..removeLast(),
    );
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.maxLines = 1,
    this.required = false,
  });

  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final int maxLines;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          required ? '$label *' : label,
          style: AppTypography.bodySmall().copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.encre,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: AppTypography.bodyMedium(),
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
        ),
      ],
    );
  }
}

class _DobField extends StatelessWidget {
  const _DobField({required this.controller});

  final ClientFormController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
        onTap: () => _pickDate(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Tr.adminClientFormDob.tr,
              style: AppTypography.bodySmall().copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.encre,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: AppColors.bg,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      controller.dateOfBirth.value != null
                          ? _formatDate(controller.dateOfBirth.value!)
                          : '—',
                      style: AppTypography.bodyMedium().copyWith(
                        color: controller.dateOfBirth.value != null
                            ? AppColors.encre
                            : AppColors.pierre,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: AppColors.pierre,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          controller.dateOfBirth.value ?? DateTime(1990),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) controller.dateOfBirth.value = picked;
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';
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
                child: TextField(
                  controller: controller.tagsInputCtrl,
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
                  onSubmitted: controller.addTag,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _GdprSection extends StatelessWidget {
  const _GdprSection({required this.controller});

  final ClientFormController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (controller.existingClient?.gdprConsentDate != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_outlined,
                    size: 16,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${Tr.adminClientFormGdprConsentDate.tr}: '
                    '${_formatDate(controller.existingClient!.gdprConsentDate!)}',
                    style: AppTypography.bodySmall().copyWith(
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          _GdprCheckbox(
            label: Tr.adminClientFormGdprEmail.tr,
            value: controller.commEmail.value,
            onChanged: (v) => controller.commEmail.value = v ?? false,
          ),
          _GdprCheckbox(
            label: Tr.adminClientFormGdprSms.tr,
            value: controller.commSms.value,
            onChanged: (v) => controller.commSms.value = v ?? false,
          ),
          _GdprCheckbox(
            label: Tr.adminClientFormGdprPhone.tr,
            value: controller.commPhone.value,
            onChanged: (v) => controller.commPhone.value = v ?? false,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) =>
      '${dt.day.toString().padLeft(2, '0')}/'
      '${dt.month.toString().padLeft(2, '0')}/'
      '${dt.year}';
}

class _GdprCheckbox extends StatelessWidget {
  const _GdprCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.terracotta,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        Text(label, style: AppTypography.bodyMedium()),
      ],
    );
  }
}

class _FormActions extends StatelessWidget {
  const _FormActions({required this.controller});

  final ClientFormController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            Tr.adminClientFormCancel.tr,
            style: AppTypography.button().copyWith(color: AppColors.pierre),
          ),
        ),
        const SizedBox(width: 12),
        Obx(
          () => FilledButton(
            onPressed:
                controller.isLoading.value ? null : controller.submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.terracotta,
              foregroundColor: Colors.white,
              textStyle: AppTypography.button(),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(Tr.adminClientFormSave.tr),
          ),
        ),
      ],
    );
  }
}
