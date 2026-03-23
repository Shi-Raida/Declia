import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/register_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../translations/translation_keys.dart';
import '../../utils/input_formatters.dart';
import '../../widgets/section_divider.dart';
import '../../widgets/staggered_fade_slide_column.dart';
import 'register_form_helpers.dart';

/// Client step 1: avatar, name, email, phone, address.
class RegisterStepPersonal extends GetView<RegisterController> {
  const RegisterStepPersonal({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.registerStep1Key,
      child: StaggeredFadeSlideColumn(
        children: [
          // ── INVITATION CODE (client only) ──
          if (controller.isClient) ...[
            registerFieldLabel(Tr.auth.register.fieldInvitationCode.tr),
            const SizedBox(height: 6),
            registerTextField(
              controller: controller.tenantSlugController,
              hint: Tr.auth.register.fieldInvitationCodeHint.tr,
              icon: Icons.vpn_key_outlined,
              action: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.lg),
          ],

          // Avatar placeholder
          _avatarPlaceholder(),
          const SizedBox(height: AppSpacing.lg),

          // ── IDENTITÉ ──────────────────────
          SectionDivider(label: Tr.auth.register.sectionIdentity.tr),
          const SizedBox(height: AppSpacing.md),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    registerFieldLabel(
                      Tr.auth.register.fieldFirstName.tr,
                      required: true,
                    ),
                    const SizedBox(height: 6),
                    registerTextField(
                      controller: controller.firstNameController,
                      hint: Tr.auth.register.fieldFirstName.tr,
                      icon: Icons.person_outline,
                      required: true,
                      action: TextInputAction.next,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    registerFieldLabel(
                      Tr.auth.register.fieldLastName.tr,
                      required: true,
                    ),
                    const SizedBox(height: 6),
                    registerTextField(
                      controller: controller.lastNameController,
                      hint: Tr.auth.register.fieldLastName.tr,
                      icon: Icons.person_outline,
                      required: true,
                      action: TextInputAction.next,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          registerFieldLabel(Tr.auth.login.email.tr, required: true),
          const SizedBox(height: 6),
          _emailField(),
          const SizedBox(height: AppSpacing.md),

          registerFieldLabel(Tr.auth.register.fieldPhone.tr, required: true),
          const SizedBox(height: 6),
          registerTextField(
            controller: controller.phoneController,
            hint: Tr.auth.register.fieldPhone.tr,
            icon: Icons.phone_outlined,
            required: true,
            keyboard: TextInputType.phone,
            action: TextInputAction.next,
            formatters: [FrenchPhoneFormatter()],
          ),
          const SizedBox(height: AppSpacing.md),

          // Company (client only, optional)
          if (controller.isClient) ...[
            registerFieldLabel(Tr.auth.register.fieldCompany.tr),
            const SizedBox(height: 6),
            registerTextField(
              controller: controller.clientCompanyController,
              hint: Tr.auth.register.fieldCompany.tr,
              icon: Icons.business_outlined,
              action: TextInputAction.next,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),

          // ── ADRESSE ───────────────────────
          SectionDivider(label: Tr.auth.register.sectionAddress.tr),
          const SizedBox(height: AppSpacing.md),

          registerTextField(
            controller: controller.streetController,
            hint: Tr.auth.register.fieldStreet.tr,
            icon: Icons.home_outlined,
            action: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.sm),

          Row(
            children: [
              SizedBox(
                width: 130,
                child: registerTextField(
                  controller: controller.postalCodeController,
                  hint: Tr.auth.register.fieldPostalCode.tr,
                  keyboard: TextInputType.number,
                  action: TextInputAction.next,
                  formatters: [PostalCodeFormatter()],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: registerTextField(
                  controller: controller.cityController,
                  hint: Tr.auth.register.fieldCity.tr,
                  action: TextInputAction.next,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          registerTextField(
            controller: controller.countryController,
            hint: Tr.auth.register.fieldCountry.tr,
            icon: Icons.flag_outlined,
            action: TextInputAction.done,
            onFieldSubmitted: (_) => controller.goToNextStep(),
          ),
        ],
      ),
    );
  }

  Widget _avatarPlaceholder() {
    return GestureDetector(
      onTap: controller.pickAvatar,
      child: Obx(() {
        final bytes = controller.avatarBytes.value;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border, width: 1.5),
            borderRadius: BorderRadius.circular(AppRadius.sm),
            color: AppColors.bgCard,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (bytes != null)
                ClipOval(
                  child: Image.memory(
                    bytes,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.border, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.pierre,
                    size: 22,
                  ),
                ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Tr.auth.register.avatarTitle.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.encre,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    Tr.auth.register.avatarHint.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: AppColors.pierre,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _emailField() {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: TextFormField(
        controller: controller.emailController,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          hintText: Tr.auth.login.emailHint.tr,
          prefixIcon: const Icon(Icons.mail_outline, size: 18),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return Tr.auth.login.emailRequired.tr;
          }
          if (!GetUtils.isEmail(value.trim())) {
            return Tr.auth.login.emailInvalid.tr;
          }
          return null;
        },
      ),
    );
  }
}
