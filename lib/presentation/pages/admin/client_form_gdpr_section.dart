import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/client_form_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import 'client_form_shared_widgets.dart';

class ClientFormGdprSection extends StatelessWidget {
  const ClientFormGdprSection({super.key, required this.controller});

  final ClientFormController controller;

  @override
  Widget build(BuildContext context) {
    return ClientFormSectionCard(
      title: Tr.adminClientFormSectionGdpr.tr,
      children: [
        Obx(
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
        ),
      ],
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
