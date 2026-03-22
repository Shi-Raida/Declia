import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/legal_form.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../translations/translation_keys.dart';
import '../../utils/input_formatters.dart';
import '../../widgets/section_divider.dart';
import '../../widgets/staggered_fade_slide_column.dart';

/// Photographer step 1: studio info + business address.
class RegisterStepStudio extends GetView<AuthController> {
  const RegisterStepStudio({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.registerStepStudioKey,
      child: StaggeredFadeSlideColumn(
        children: [
          // ── STUDIO ────────────────────────
          SectionDivider(label: Tr.registerSectionStudio.tr),
          const SizedBox(height: AppSpacing.md),

          _label(Tr.registerFieldStudioName.tr, required: true),
          const SizedBox(height: 6),
          _field(
            controller: controller.studioNameController,
            hint: Tr.registerFieldStudioName.tr,
            icon: Icons.camera_alt_outlined,
            required: true,
          ),
          const SizedBox(height: AppSpacing.md),

          _label(Tr.registerFieldCompanyName.tr),
          const SizedBox(height: 6),
          _field(
            controller: controller.companyNameController,
            hint: Tr.registerFieldCompanyName.tr,
            icon: Icons.business_outlined,
          ),
          const SizedBox(height: AppSpacing.md),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(Tr.registerFieldSiret.tr),
                    const SizedBox(height: 6),
                    _field(
                      controller: controller.siretController,
                      hint: Tr.registerFieldSiret.tr,
                      keyboard: TextInputType.number,
                      formatters: [SiretFormatter()],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(Tr.registerFieldLegalForm.tr),
                    const SizedBox(height: 6),
                    Obx(
                      () => DropdownButtonFormField<LegalForm?>(
                        initialValue: controller.legalForm.value,
                        decoration: InputDecoration(
                          hintText: Tr.registerFieldLegalForm.tr,
                        ),
                        items: [
                          const DropdownMenuItem(value: null, child: Text('—')),
                          ...LegalForm.values.map(
                            (lf) => DropdownMenuItem(
                              value: lf,
                              child: Text(lf.trKey.tr),
                            ),
                          ),
                        ],
                        onChanged: (v) => controller.legalForm.value = v,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // "Other" free text field
          Obx(() {
            if (controller.legalForm.value != LegalForm.other) {
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: _field(
                controller: controller.legalFormOtherController,
                hint: Tr.legalFormOtherSpecify.tr,
                required: true,
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),

          _label(Tr.registerFieldVatNumber.tr),
          const SizedBox(height: 6),
          _field(
            controller: controller.vatNumberController,
            hint: 'FRXX XXX XXX XXX',
            formatters: [VatNumberFormatter()],
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── ADRESSE PROFESSIONNELLE ───────
          SectionDivider(label: Tr.registerSectionBizAddress.tr),
          const SizedBox(height: AppSpacing.md),

          _field(
            controller: controller.bizStreetController,
            hint: Tr.registerFieldBizStreet.tr,
            icon: Icons.home_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),

          Row(
            children: [
              SizedBox(
                width: 130,
                child: _field(
                  controller: controller.bizPostalCodeController,
                  hint: Tr.registerFieldBizPostalCode.tr,
                  keyboard: TextInputType.number,
                  formatters: [PostalCodeFormatter()],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _field(
                  controller: controller.bizCityController,
                  hint: Tr.registerFieldBizCity.tr,
                  action: TextInputAction.done,
                  onFieldSubmitted: (_) => controller.goToNextStep(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 12.8,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.3,
            color: AppColors.grisTexte,
          ),
        ),
        if (required)
          Text(
            ' *',
            style: GoogleFonts.outfit(
              fontSize: 12.8,
              fontWeight: FontWeight.w600,
              color: AppColors.error,
            ),
          ),
      ],
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    bool required = false,
    TextInputType? keyboard,
    TextInputAction action = TextInputAction.next,
    List<TextInputFormatter>? formatters,
    ValueChanged<String>? onFieldSubmitted,
  }) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        textInputAction: action,
        inputFormatters: formatters,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: icon != null ? Icon(icon, size: 18) : null,
        ),
        validator: required
            ? (value) {
                if (value == null || value.trim().isEmpty) {
                  return Tr.registerFieldRequired.tr;
                }
                return null;
              }
            : null,
      ),
    );
  }
}

extension LegalFormTr on LegalForm {
  String get trKey => switch (this) {
    LegalForm.autoEntrepreneur => Tr.legalFormAutoEntrepreneur,
    LegalForm.ei => Tr.legalFormEi,
    LegalForm.eurl => Tr.legalFormEurl,
    LegalForm.sarl => Tr.legalFormSarl,
    LegalForm.sas => Tr.legalFormSas,
    LegalForm.sasu => Tr.legalFormSasu,
    LegalForm.other => Tr.legalFormOther,
  };
}
