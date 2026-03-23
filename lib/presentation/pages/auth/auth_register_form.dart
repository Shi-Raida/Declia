import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/register_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/animated_error_banner.dart';
import 'register_navigation_bar.dart';
import 'register_progress_bar.dart';
import 'register_step_business.dart';
import 'register_step_confirm.dart';
import 'register_step_personal.dart';
import 'register_step_security.dart';
import 'register_step_studio.dart';

class AuthRegisterForm extends GetView<RegisterController> {
  const AuthRegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isRegisterSuccess.value) {
        return _SuccessView(controller: controller);
      }
      return _WizardView(controller: controller);
    });
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.controller});

  final RegisterController controller;

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
          Tr.auth.register.success.tr,
          textAlign: TextAlign.center,
          style: AppTypography.bodyMedium(),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: controller.goToLogin,
          child: Text(
            Tr.auth.forgot.backToLogin.tr,
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

class _WizardView extends StatelessWidget {
  const _WizardView({required this.controller});

  final RegisterController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final accentColor = controller.accentColor;
      final isClient = controller.isClient;
      final step = controller.registerStep.value;
      final totalSteps = controller.totalSteps;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            isClient
                ? Tr.auth.register.titleClient.tr
                : Tr.auth.register.titlePhotographer.tr,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.encre,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isClient
                ? Tr.auth.register.subtitleClient.tr
                : Tr.auth.register.subtitlePhotographer.tr,
            style: AppTypography.bodySmall(),
          ),
          const SizedBox(height: 20),

          // Progress bar
          RegisterProgressBar(
            currentStep: step,
            totalSteps: totalSteps,
            accentColor: accentColor,
          ),
          const SizedBox(height: 20),

          // Error message
          Obx(
            () => AnimatedErrorBanner(message: controller.errorMessage.value),
          ),

          // Step content
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            alignment: Alignment.topLeft,
            curve: Curves.easeOutCubic,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              layoutBuilder: (currentChild, _) =>
                  currentChild ?? const SizedBox.shrink(),
              child: SizedBox(
                key: ValueKey('register_step_${step}_$isClient'),
                width: double.infinity,
                child: _buildStep(step, isClient),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Navigation buttons
          RegisterNavigationBar(
            step: step,
            totalSteps: totalSteps,
            controller: controller,
            accentColor: accentColor,
          ),
          const SizedBox(height: 16),

          // Footer sign-in link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                Tr.auth.register.footerHaveAccount.tr,
                style: AppTypography.bodySmall(),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: controller.goToLogin,
                child: Text(
                  Tr.auth.register.footerSignIn.tr,
                  style: AppTypography.bodySmall().copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildStep(int step, bool isClient) {
    if (isClient) {
      return switch (step) {
        0 => const RegisterStepPersonal(),
        1 => const RegisterStepSecurity(),
        _ => const RegisterStepConfirm(),
      };
    }
    return switch (step) {
      0 => const RegisterStepBusiness(),
      1 => const RegisterStepStudio(),
      2 => const RegisterStepSecurity(),
      _ => const RegisterStepConfirm(),
    };
  }
}
