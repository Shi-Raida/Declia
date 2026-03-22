import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../translations/translation_keys.dart';
import '../../utils/input_formatters.dart';
import '../../widgets/section_divider.dart';
import '../../widgets/staggered_fade_slide_column.dart';

/// Photographer step 0: avatar, name, email, phone.
class RegisterStepBusiness extends GetView<AuthController> {
  const RegisterStepBusiness({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.registerStep1Key,
      child: StaggeredFadeSlideColumn(
        children: [
          // Avatar placeholder
          _avatarPlaceholder(),
          const SizedBox(height: AppSpacing.lg),

          // ── IDENTITÉ ──────────────────────
          SectionDivider(label: Tr.registerSectionIdentity.tr),
          const SizedBox(height: AppSpacing.md),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(Tr.registerFieldFirstName.tr, required: true),
                    const SizedBox(height: 6),
                    _field(
                      controller: controller.firstNameController,
                      hint: Tr.registerFieldFirstName.tr,
                      icon: Icons.person_outline,
                      required: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _label(Tr.registerFieldLastName.tr, required: true),
                    const SizedBox(height: 6),
                    _field(
                      controller: controller.lastNameController,
                      hint: Tr.registerFieldLastName.tr,
                      icon: Icons.person_outline,
                      required: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          _label(Tr.loginEmail.tr, required: true),
          const SizedBox(height: 6),
          _emailField(),
          const SizedBox(height: AppSpacing.md),

          _label(Tr.registerFieldPhone.tr, required: true),
          const SizedBox(height: 6),
          _field(
            controller: controller.phoneController,
            hint: Tr.registerFieldPhone.tr,
            icon: Icons.phone_outlined,
            required: true,
            keyboard: TextInputType.phone,
            action: TextInputAction.done,
            formatters: [FrenchPhoneFormatter()],
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
                    Tr.registerAvatarTitle.tr,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.encre,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    Tr.registerAvatarHint.tr,
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
          hintText: Tr.loginEmailHint.tr,
          prefixIcon: const Icon(Icons.mail_outline, size: 18),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return Tr.loginEmailRequired.tr;
          }
          if (!GetUtils.isEmail(value.trim())) {
            return Tr.loginEmailInvalid.tr;
          }
          return null;
        },
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
