import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/auth_controller.dart';
import '../../theme/app_colors.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/staggered_fade_slide_column.dart';

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
    final step = controller.registerStep.value;

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
                child: _StepIndicatorRow(
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo
        Image.asset('assets/images/logo.png', width: 110, height: 110),
        const SizedBox(height: 40),
        // Tagline + subtitle
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
            child: StaggeredFadeSlideColumn(
              key: ValueKey('left_$isClient'),
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: isClient
                            ? Tr.loginClientTagline.tr
                            : Tr.loginTagline.tr,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.3,
                        ),
                      ),
                      TextSpan(
                        text: isClient
                            ? Tr.loginClientTaglineHighlight.tr
                            : Tr.loginTaglineHighlight.tr,
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
                const SizedBox(height: 16),
                Text(
                  isClient ? Tr.loginClientSubtitle.tr : Tr.loginSubtitle.tr,
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
        const SizedBox(height: 48),
        // Feature bullets
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          layoutBuilder: (currentChild, _) =>
              currentChild ?? const SizedBox.shrink(),
          child: StaggeredFadeSlideColumn(
            key: ValueKey('features_$isClient'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                (isClient
                        ? [
                            Tr.loginClientFeature1.tr,
                            Tr.loginClientFeature2.tr,
                            Tr.loginClientFeature3.tr,
                            Tr.loginClientFeature4.tr,
                          ]
                        : [
                            Tr.loginFeature1.tr,
                            Tr.loginFeature2.tr,
                            Tr.loginFeature3.tr,
                            Tr.loginFeature4.tr,
                          ])
                    .map(
                      (feature) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.or,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              feature,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                color: Colors.white.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
      ],
    );
  }
}

class _StepIndicatorRow extends StatelessWidget {
  const _StepIndicatorRow({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.isDone,
    required this.isActive,
  });

  final int stepNumber;
  final String title;
  final String description;
  final bool isDone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    Color circleBg;
    Color circleContent;
    Color titleColor;
    Color descColor;

    if (isDone) {
      circleBg = AppColors.success.withValues(alpha: 0.25);
      circleContent = AppColors.success;
      titleColor = Colors.white.withValues(alpha: 0.7);
      descColor = Colors.white.withValues(alpha: 0.4);
    } else if (isActive) {
      circleBg = AppColors.or;
      circleContent = AppColors.crepuscule;
      titleColor = Colors.white;
      descColor = Colors.white.withValues(alpha: 0.6);
    } else {
      circleBg = Colors.transparent;
      circleContent = Colors.white.withValues(alpha: 0.3);
      titleColor = Colors.white.withValues(alpha: 0.3);
      descColor = Colors.white.withValues(alpha: 0.2);
    }

    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: circleBg,
            shape: BoxShape.circle,
            border: isDone || isActive
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
          ),
          child: Center(
            child: isDone
                ? Icon(Icons.check, size: 18, color: circleContent)
                : Text(
                    '$stepNumber',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: circleContent,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: titleColor,
                ),
                child: Text(title),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: descColor,
                ),
                child: Text(description),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
