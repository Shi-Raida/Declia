import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/acquisition_source.dart';
import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/section_divider.dart';
import '../../widgets/staggered_fade_slide_column.dart';
import '../admin/clients_filter_bar.dart';

/// Step 2 (shared): password, confirm password, acquisition source & notes.
class RegisterStepSecurity extends GetView<AuthController> {
  const RegisterStepSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.registerStep2Key,
      child: StaggeredFadeSlideColumn(
        children: [
          _label(Tr.loginPassword.tr, required: true),
          const SizedBox(height: 6),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: Obx(
              () => TextFormField(
                controller: controller.passwordController,
                obscureText: !controller.isPasswordVisible.value,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline, size: 18),
                  helperText: Tr.registerPasswordHint.tr,
                  helperMaxLines: 2,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                    style: IconButton.styleFrom(
                      foregroundColor: AppColors.grisTexte,
                      hoverColor: Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Tr.loginPasswordRequired.tr;
                  }
                  if (value.length < 8 ||
                      !value.contains(RegExp(r'[A-Z]')) ||
                      !value.contains(RegExp(r'[a-z]')) ||
                      !value.contains(RegExp(r'[0-9]')) ||
                      !value.contains(RegExp(r'[^A-Za-z0-9]'))) {
                    return Tr.registerPasswordTooWeak.tr;
                  }
                  return null;
                },
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Password strength indicator
          Obx(() {
            final strength = controller.passwordStrength.value;
            const colors = [
              AppColors.error,
              AppColors.error,
              Color(0xFFF59E0B), // amber
              Color(0xFF10B981), // green
              AppColors.success,
            ];
            return Row(
              children: List.generate(4, (i) {
                final active = i < strength;
                return Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    height: 4,
                    margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                    decoration: BoxDecoration(
                      color: active
                          ? colors[strength.clamp(0, 4)]
                          : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            );
          }),
          const SizedBox(height: AppSpacing.md),

          _label(Tr.clientRegisterConfirmPassword.tr, required: true),
          const SizedBox(height: 6),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOutCubic,
            alignment: Alignment.topCenter,
            child: TextFormField(
              controller: controller.confirmPasswordController,
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => controller.goToNextStep(),
              decoration: const InputDecoration(
                hintText: '••••••••',
                prefixIcon: Icon(Icons.lock_outline, size: 18),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return Tr.clientRegisterConfirmPasswordRequired.tr;
                }
                if (value != controller.passwordController.text) {
                  return Tr.clientRegisterPasswordMismatch.tr;
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── PRÉFÉRENCES ───────────────────
          SectionDivider(label: Tr.registerSectionPreferences.tr),
          const SizedBox(height: AppSpacing.md),

          _label(Tr.registerFieldAcquisitionSource.tr),
          const SizedBox(height: 6),
          Obx(
            () => DropdownButtonFormField<AcquisitionSource?>(
              initialValue: controller.acquisitionSource.value,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.people_outline, size: 18),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('—')),
                ...AcquisitionSource.values.map(
                  (src) =>
                      DropdownMenuItem(value: src, child: Text(src.trKey.tr)),
                ),
              ],
              onChanged: (v) => controller.acquisitionSource.value = v,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _label(Tr.registerFieldNotes.tr),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller.notesController,
            maxLines: 3,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: Tr.registerFieldNotes.tr,
              prefixIcon: const Icon(Icons.notes_outlined, size: 18),
            ),
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
}
