import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/legal_form.dart';
import '../../controllers/register_controller.dart';
import '../../theme/app_spacing.dart';
import '../../translations/translation_keys.dart';
import '../../utils/input_formatters.dart';
import '../../utils/validators.dart';
import '../../widgets/section_divider.dart';
import '../../widgets/staggered_fade_slide_column.dart';
import 'register_form_helpers.dart';

/// Photographer step 1: studio info + business address.
class RegisterStepStudio extends GetView<RegisterController> {
  const RegisterStepStudio({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.registerStepStudioKey,
      child: StaggeredFadeSlideColumn(
        children: [
          // ── STUDIO ────────────────────────
          SectionDivider(label: Tr.auth.register.sectionStudio.tr),
          const SizedBox(height: AppSpacing.md),

          registerFieldLabel(
            Tr.auth.register.fieldStudioName.tr,
            required: true,
          ),
          const SizedBox(height: 6),
          registerTextField(
            controller: controller.studioNameController,
            hint: Tr.auth.register.fieldStudioName.tr,
            icon: Icons.camera_alt_outlined,
            required: true,
          ),
          const SizedBox(height: AppSpacing.md),

          registerFieldLabel(Tr.auth.register.fieldCompanyName.tr),
          const SizedBox(height: 6),
          registerTextField(
            controller: controller.companyNameController,
            hint: Tr.auth.register.fieldCompanyName.tr,
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
                    registerFieldLabel(Tr.auth.register.fieldSiret.tr),
                    const SizedBox(height: 6),
                    registerTextField(
                      controller: controller.siretController,
                      hint: Tr.auth.register.fieldSiret.tr,
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
                    registerFieldLabel(Tr.auth.register.fieldLegalForm.tr),
                    const SizedBox(height: 6),
                    Obx(
                      () => DropdownButtonFormField<LegalForm?>(
                        initialValue: controller.legalForm.value,
                        decoration: InputDecoration(
                          hintText: Tr.auth.register.fieldLegalForm.tr,
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
              child: registerTextField(
                controller: controller.legalFormOtherController,
                hint: Tr.common.legalForm.otherSpecify.tr,
                required: true,
              ),
            );
          }),
          const SizedBox(height: AppSpacing.md),

          registerFieldLabel(Tr.auth.register.fieldVatNumber.tr),
          const SizedBox(height: 6),
          registerTextField(
            controller: controller.vatNumberController,
            hint: 'FRXX XXX XXX XXX',
            formatters: [VatNumberFormatter()],
            validator: (v) => validateFrenchVat(v)?.tr,
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── ADRESSE PROFESSIONNELLE ───────
          SectionDivider(label: Tr.auth.register.sectionBizAddress.tr),
          const SizedBox(height: AppSpacing.md),

          registerTextField(
            controller: controller.bizStreetController,
            hint: Tr.auth.register.fieldBizStreet.tr,
            icon: Icons.home_outlined,
          ),
          const SizedBox(height: AppSpacing.sm),

          Row(
            children: [
              SizedBox(
                width: 130,
                child: registerTextField(
                  controller: controller.bizPostalCodeController,
                  hint: Tr.auth.register.fieldBizPostalCode.tr,
                  keyboard: TextInputType.number,
                  formatters: [PostalCodeFormatter()],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: registerTextField(
                  controller: controller.bizCityController,
                  hint: Tr.auth.register.fieldBizCity.tr,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          registerTextField(
            controller: controller.bizCountryController,
            hint: Tr.auth.register.fieldBizCountry.tr,
            icon: Icons.flag_outlined,
            action: TextInputAction.done,
            onFieldSubmitted: (_) => controller.goToNextStep(),
          ),
        ],
      ),
    );
  }
}

extension LegalFormTr on LegalForm {
  String get trKey => switch (this) {
    LegalForm.autoEntrepreneur => Tr.common.legalForm.autoEntrepreneur,
    LegalForm.ei => Tr.common.legalForm.ei,
    LegalForm.eurl => Tr.common.legalForm.eurl,
    LegalForm.sarl => Tr.common.legalForm.sarl,
    LegalForm.sas => Tr.common.legalForm.sas,
    LegalForm.sasu => Tr.common.legalForm.sasu,
    LegalForm.microEntreprise => Tr.common.legalForm.microEntreprise,
    LegalForm.association => Tr.common.legalForm.association,
    LegalForm.other => Tr.common.legalForm.other,
  };
}
