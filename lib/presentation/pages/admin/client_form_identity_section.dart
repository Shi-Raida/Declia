import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/client_form_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import 'client_form_shared_widgets.dart';

class ClientFormIdentitySection extends StatelessWidget {
  const ClientFormIdentitySection({super.key, required this.controller});

  final ClientFormController controller;

  @override
  Widget build(BuildContext context) {
    return ClientFormSectionCard(
      title: Tr.adminClientFormSectionIdentity.tr,
      children: [
        ClientFormRow(
          children: [
            ClientFormTextField(
              label: Tr.adminClientFormFirstName.tr,
              controller: controller.firstNameCtrl,
              required: true,
            ),
            ClientFormTextField(
              label: Tr.adminClientFormLastName.tr,
              controller: controller.lastNameCtrl,
              required: true,
            ),
          ],
        ),
        ClientFormRow(
          children: [
            ClientFormTextField(
              label: Tr.adminClientFormEmail.tr,
              controller: controller.emailCtrl,
              keyboardType: TextInputType.emailAddress,
            ),
            ClientFormTextField(
              label: Tr.adminClientFormPhone.tr,
              controller: controller.phoneCtrl,
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        _DobField(controller: controller),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
      initialDate: controller.dateOfBirth.value ?? DateTime(1990),
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
