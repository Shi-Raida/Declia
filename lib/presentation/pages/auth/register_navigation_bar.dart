import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/register_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class RegisterNavigationBar extends StatelessWidget {
  const RegisterNavigationBar({
    required this.step,
    required this.totalSteps,
    required this.controller,
    required this.accentColor,
    super.key,
  });

  final int step;
  final int totalSteps;
  final RegisterController controller;
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
