import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/animated_error_banner.dart';
import '../../widgets/staggered_fade_slide_column.dart';

class AuthForgotPasswordForm extends GetView<AuthController> {
  const AuthForgotPasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isForgotSuccess.value) {
        return _SuccessView(controller: controller);
      }
      return _FormView(controller: controller);
    });
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.mark_email_read_outlined,
          size: 64,
          color: AppColors.success,
        ),
        const SizedBox(height: 24),
        Text(
          Tr.authForgotSuccess.tr,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium(),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: controller.goToLogin,
          child: Text(
            Tr.authForgotBackToLogin.tr,
            style: AppTypography.bodySmall().copyWith(
              color: controller.accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _FormView extends StatelessWidget {
  const _FormView({required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final accentColor = controller.accentColor;
      final isClient = controller.selectedRole.value == 0;

      return Form(
        key: controller.forgotFormKey,
        child: StaggeredFadeSlideColumn(
          children: [
            // Title
            Text(
              isClient
                  ? Tr.authForgotTitle.tr
                  : Tr.authForgotTitlePhotographer.tr,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppColors.encre,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isClient
                  ? Tr.authForgotSubtitle.tr
                  : Tr.authForgotSubtitlePhotographer.tr,
              style: AppTypography.bodySmall(),
            ),
            const SizedBox(height: 20),

            // Error message
            Obx(
              () => AnimatedErrorBanner(message: controller.errorMessage.value),
            ),

            // Email field
            Text(
              Tr.loginEmail.tr.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 12.8,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.3,
                color: AppColors.grisTexte,
              ),
            ),
            const SizedBox(height: 6),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: TextFormField(
                controller: controller.forgotEmailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => controller.submitForgotPassword(),
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
            ),
            const SizedBox(height: AppSpacing.lg),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.submitForgotPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          Tr.authForgotSubmit.tr,
                          style: AppTypography.button().copyWith(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Back to login link
            Center(
              child: TextButton(
                onPressed: controller.goToLogin,
                style: TextButton.styleFrom(
                  foregroundColor: accentColor,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  Tr.authForgotBackToLogin.tr,
                  style: AppTypography.bodySmall().copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
