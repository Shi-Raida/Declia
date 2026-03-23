import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/legal_form.dart';
import '../../controllers/register_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/staggered_fade_slide_column.dart';
import '../admin/acquisition_source_tr.dart';
import 'register_step_studio.dart';

/// Step 3 (shared): summary card + consent checkboxes.
class RegisterStepConfirm extends GetView<RegisterController> {
  const RegisterStepConfirm({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isClient = controller.isClient;
      final accentColor = controller.accentColor;

      return StaggeredFadeSlideColumn(
        children: [
          // Summary card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Tr.auth.register.summaryTitle.tr,
                  style: GoogleFonts.cormorantGaramond(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.encre,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Identity
                _sectionLabel(Tr.auth.register.summaryIdentity.tr),
                _summaryRow(
                  '${controller.firstNameController.text} '
                  '${controller.lastNameController.text}',
                ),
                if (isClient &&
                    controller.tenantSlugController.text.trim().isNotEmpty)
                  _summaryRow(
                    '${Tr.auth.register.fieldInvitationCode.tr}: '
                    '${controller.tenantSlugController.text}',
                  ),
                if (isClient &&
                    controller.clientCompanyController.text.trim().isNotEmpty)
                  _summaryRow(
                    '${Tr.auth.register.fieldCompany.tr}: '
                    '${controller.clientCompanyController.text}',
                  ),
                const SizedBox(height: AppSpacing.sm),

                // Contact
                _sectionLabel(Tr.auth.register.summaryContact.tr),
                _summaryRow(controller.emailController.text),
                if (controller.phoneController.text.trim().isNotEmpty)
                  _summaryRow(controller.phoneController.text),
                const SizedBox(height: AppSpacing.sm),

                // Address (client)
                if (isClient &&
                    _hasAny([
                      controller.streetController,
                      controller.cityController,
                    ])) ...[
                  _sectionLabel(Tr.auth.register.summaryAddress.tr),
                  if (controller.streetController.text.trim().isNotEmpty)
                    _summaryRow(controller.streetController.text),
                  _summaryRow(
                    [
                      controller.postalCodeController.text.trim(),
                      controller.cityController.text.trim(),
                    ].where((s) => s.isNotEmpty).join(' '),
                  ),
                  if (controller.countryController.text.trim().isNotEmpty)
                    _summaryRow(controller.countryController.text),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // Studio (photographer)
                if (!isClient) ...[
                  _sectionLabel(Tr.auth.register.sectionStudio.tr),
                  _summaryRow(controller.studioNameController.text),
                  if (controller.companyNameController.text.trim().isNotEmpty)
                    _summaryRow(controller.companyNameController.text),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // Legal info (photographer)
                if (!isClient &&
                        _hasAny([
                          controller.siretController,
                          controller.vatNumberController,
                        ]) ||
                    (!isClient && controller.legalForm.value != null)) ...[
                  _sectionLabel(Tr.auth.register.summaryBusiness.tr),
                  if (controller.siretController.text.trim().isNotEmpty)
                    _summaryRow(
                      '${Tr.auth.register.fieldSiret.tr}: '
                      '${controller.siretController.text}',
                    ),
                  if (controller.legalForm.value != null)
                    _summaryRow(
                      '${Tr.auth.register.fieldLegalForm.tr}: '
                      '${_legalFormDisplay()}',
                    ),
                  if (controller.vatNumberController.text.trim().isNotEmpty)
                    _summaryRow(
                      '${Tr.auth.register.fieldVatNumber.tr}: '
                      '${controller.vatNumberController.text}',
                    ),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // Business address (photographer)
                if (!isClient &&
                    _hasAny([
                      controller.bizStreetController,
                      controller.bizCityController,
                    ])) ...[
                  _sectionLabel(Tr.auth.register.sectionBizAddress.tr),
                  if (controller.bizStreetController.text.trim().isNotEmpty)
                    _summaryRow(controller.bizStreetController.text),
                  _summaryRow(
                    [
                      controller.bizPostalCodeController.text.trim(),
                      controller.bizCityController.text.trim(),
                    ].where((s) => s.isNotEmpty).join(' '),
                  ),
                  if (controller.bizCountryController.text.trim().isNotEmpty)
                    _summaryRow(controller.bizCountryController.text),
                  const SizedBox(height: AppSpacing.sm),
                ],

                // Preferences
                if (controller.acquisitionSource.value != null ||
                    controller.notesController.text.trim().isNotEmpty) ...[
                  _sectionLabel(Tr.auth.register.sectionPreferences.tr),
                  if (controller.acquisitionSource.value != null)
                    _summaryRow(
                      '${Tr.auth.register.fieldAcquisitionSource.tr}: '
                      '${controller.acquisitionSource.value!.trKey.tr}',
                    ),
                  if (controller.notesController.text.trim().isNotEmpty)
                    _summaryRow(controller.notesController.text),
                  const SizedBox(height: AppSpacing.sm),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Consent checkboxes — CGU + privacy policy (both roles)
          _cguConsentRow(
            value: controller.cguAccepted.value,
            onChanged: (v) => controller.cguAccepted.value = v,
            accentColor: accentColor,
          ),
          // Marketing (both roles)
          const SizedBox(height: AppSpacing.sm),
          _consentRow(
            value: controller.emailMarketingAccepted.value,
            onChanged: (v) => controller.emailMarketingAccepted.value = v,
            label: Tr.auth.register.consentMarketing.tr,
            accentColor: accentColor,
          ),
        ],
      );
    });
  }

  String _legalFormDisplay() {
    final lf = controller.legalForm.value;
    if (lf == null) return '';
    if (lf == LegalForm.other) {
      final other = controller.legalFormOtherController.text.trim();
      return other.isNotEmpty ? other : lf.trKey.tr;
    }
    return lf.trKey.tr;
  }

  bool _hasAny(List<TextEditingController> controllers) {
    return controllers.any((c) => c.text.trim().isNotEmpty);
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.8,
          color: AppColors.pierre,
        ),
      ),
    );
  }

  Widget _summaryRow(String text) {
    if (text.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(text.trim(), style: AppTypography.bodySmall()),
    );
  }

  /// CGU consent row with tappable links for CGU and privacy policy.
  Widget _cguConsentRow({
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color accentColor,
  }) {
    final style = AppTypography.bodySmall();
    final linkStyle = style.copyWith(
      color: accentColor,
      decoration: TextDecoration.underline,
      decorationColor: accentColor,
    );

    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              activeColor: accentColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: Tr.auth.register.consentCguPrefix.tr,
                    style: style,
                  ),
                  TextSpan(
                    text: Tr.auth.register.consentCguLink.tr,
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.toNamed(AppRoutes.legalNotices),
                  ),
                  TextSpan(
                    text: Tr.auth.register.consentCguMiddle.tr,
                    style: style,
                  ),
                  TextSpan(
                    text: Tr.auth.register.consentPrivacyLink.tr,
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Get.toNamed(AppRoutes.legalPrivacy),
                  ),
                  TextSpan(text: ' *', style: style),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _consentRow({
    required bool value,
    required ValueChanged<bool> onChanged,
    required String label,
    required Color accentColor,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              activeColor: accentColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: AppTypography.bodySmall())),
        ],
      ),
    );
  }
}
