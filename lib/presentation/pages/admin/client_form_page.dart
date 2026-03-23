import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/client_form_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';
import 'client_form_crm_section.dart';
import 'client_form_gdpr_section.dart';
import 'client_form_identity_section.dart';
import 'client_form_shared_widgets.dart';

class ClientFormPage extends GetView<ClientFormController> {
  const ClientFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => AdminLayout(
        title: controller.isEditing
            ? Tr.admin.clientForm.titleEdit.tr
            : Tr.admin.clientForm.titleCreate.tr,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClientFormIdentitySection(controller: controller),
                  const SizedBox(height: 16),
                  _AddressSection(controller: controller),
                  const SizedBox(height: 16),
                  ClientFormCrmSection(controller: controller),
                  const SizedBox(height: 16),
                  ClientFormGdprSection(controller: controller),
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

class _AddressSection extends StatelessWidget {
  const _AddressSection({required this.controller});

  final ClientFormController controller;

  @override
  Widget build(BuildContext context) {
    return ClientFormSectionCard(
      title: Tr.admin.clientForm.sectionAddress.tr,
      children: [
        ClientFormTextField(
          label: Tr.admin.clientForm.street.tr,
          controller: controller.streetCtrl,
        ),
        ClientFormRow(
          children: [
            ClientFormTextField(
              label: Tr.admin.clientForm.city.tr,
              controller: controller.cityCtrl,
            ),
            ClientFormTextField(
              label: Tr.admin.clientForm.postalCode.tr,
              controller: controller.postalCodeCtrl,
            ),
          ],
        ),
        ClientFormTextField(
          label: Tr.admin.clientForm.country.tr,
          controller: controller.countryCtrl,
        ),
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
          onPressed: () => controller.cancel(),
          child: Text(
            Tr.admin.clientForm.cancel.tr,
            style: AppTypography.button().copyWith(color: AppColors.pierre),
          ),
        ),
        const SizedBox(width: 12),
        Obx(
          () => FilledButton(
            onPressed: controller.isLoading.value ? null : controller.submit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.terracotta,
              foregroundColor: Colors.white,
              textStyle: AppTypography.button(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                : Text(Tr.admin.clientForm.save.tr),
          ),
        ),
      ],
    );
  }
}
