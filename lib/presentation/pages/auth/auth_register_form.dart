import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/animated_error_banner.dart';
import 'register_step_business.dart';
import 'register_step_confirm.dart';
import 'register_step_personal.dart';
import 'register_step_security.dart';
import 'register_step_studio.dart';

class AuthRegisterForm extends GetView<AuthController> {
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
          Tr.authRegisterSuccess.tr,
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

class _WizardView extends StatelessWidget {
  const _WizardView({required this.controller});

  final AuthController controller;

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
                ? Tr.authRegisterTitleClient.tr
                : Tr.authRegisterTitlePhotographer.tr,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.encre,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            isClient
                ? Tr.authRegisterSubtitleClient.tr
                : Tr.authRegisterSubtitlePhotographer.tr,
            style: AppTypography.bodySmall(),
          ),
          const SizedBox(height: 20),

          // Progress bar
          _ProgressBar(
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
          _NavigationBar(
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
                Tr.authRegisterFooterHaveAccount.tr,
                style: AppTypography.bodySmall(),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: controller.goToLogin,
                child: Text(
                  Tr.authRegisterFooterSignIn.tr,
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

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.currentStep,
    required this.totalSteps,
    required this.accentColor,
  });

  final int currentStep;
  final int totalSteps;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final isDone = i < currentStep;
        final isActive = i == currentStep;

        Color color;
        if (isDone) {
          color = AppColors.success;
        } else if (isActive) {
          color = accentColor;
        } else {
          color = AppColors.border;
        }

        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: 4,
            margin: EdgeInsets.only(right: i < totalSteps - 1 ? 6 : 0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}

class _NavigationBar extends StatelessWidget {
  const _NavigationBar({
    required this.step,
    required this.totalSteps,
    required this.controller,
    required this.accentColor,
  });

  final int step;
  final int totalSteps;
  final AuthController controller;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final isLastStep = step == totalSteps - 1;

    return Row(
      children: [
        // Back button
        if (step > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: controller.goToPreviousStep,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.encre,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(Tr.registerBtnBack.tr, style: AppTypography.button()),
            ),
          ),
        if (step > 0) const SizedBox(width: 12),

        // Continue / Submit button
        Expanded(
          flex: step > 0 ? 2 : 1,
          child: Obx(
            () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : isLastStep
                  ? controller.register
                  : controller.goToNextStep,
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
                      isLastStep
                          ? Tr.registerBtnSubmit.tr
                          : Tr.registerBtnContinue.tr,
                      style: AppTypography.button().copyWith(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
