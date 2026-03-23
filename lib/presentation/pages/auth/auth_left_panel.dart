import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../translations/translation_keys.dart';
import 'auth_left_panel_features.dart';
import 'auth_step_indicator_row.dart';

class AuthLeftPanel extends GetView<AuthController> {
  const AuthLeftPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.crepuscule,
      child: Stack(
        children: [
          // Decorative gradient backgrounds
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomLeft,
                  radius: 1.0,
                  colors: [
                    AppColors.or.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.0,
                  colors: [
                    AppColors.bleuOuvert.withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 0.8,
                  colors: [
                    AppColors.terracotta.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Content
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(48),
              child: Obx(() => _buildContent()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final isRegister = controller.currentView.value == AuthView.register;
    if (isRegister) return _buildRegisterContent();
    return _buildFeaturesContent();
  }

  Widget _buildRegisterContent() {
    final isClient = controller.selectedRole.value == 0;
    final step = controller.registerStepValue;

    final steps = isClient
        ? [
            (Tr.registerStepPersonal.tr, Tr.registerStepPersonalDesc.tr),
            (Tr.registerStepSecurity.tr, Tr.registerStepSecurityDesc.tr),
            (
              Tr.registerStepConfirmation.tr,
              Tr.registerStepConfirmationDesc.tr,
            ),
          ]
        : [
            (Tr.registerStepBusiness.tr, Tr.registerStepBusinessDesc.tr),
            (Tr.registerStepStudio.tr, Tr.registerStepStudioDesc.tr),
            (Tr.registerStepSecurity.tr, Tr.registerStepSecurityDesc.tr),
            (
              Tr.registerStepConfirmation.tr,
              Tr.registerStepConfirmationDesc.tr,
            ),
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo
        Image.asset('assets/images/logo.png', width: 110, height: 110),
        const SizedBox(height: 32),

        // Tagline
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            layoutBuilder: (currentChild, _) =>
                currentChild ?? const SizedBox.shrink(),
            child: Column(
              key: ValueKey('register_left_$isClient'),
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: isClient
                            ? Tr.registerLeftTaglineClient.tr
                            : Tr.registerLeftTaglinePhotographer.tr,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                      TextSpan(
                        text: isClient
                            ? Tr.registerLeftTaglineClientHighlight.tr
                            : Tr.registerLeftTaglinePhotographerHighlight.tr,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.italic,
                          color: AppColors.or,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isClient
                      ? Tr.registerLeftSubtitleClient.tr
                      : Tr.registerLeftSubtitlePhotographer.tr,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withValues(alpha: 0.6),
                    height: 1.7,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40),

        // Step indicator
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Column(
            children: List.generate(steps.length, (i) {
              final isDone = i < step;
              final isActive = i == step;

              return Padding(
                padding: EdgeInsets.only(bottom: i < steps.length - 1 ? 12 : 0),
                child: AuthStepIndicatorRow(
                  stepNumber: i + 1,
                  title: steps[i].$1,
                  description: steps[i].$2,
                  isDone: isDone,
                  isActive: isActive,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesContent() {
    final isClient = controller.selectedRole.value == 0;
    return AuthLeftPanelFeatures(isClient: isClient);
  }
}
