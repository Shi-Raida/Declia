import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/auth_controller.dart';
import '../../theme/app_breakpoints.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../translations/translation_keys.dart';
import 'auth_forgot_password_form.dart';
import 'auth_left_panel.dart';
import 'auth_login_form.dart';
import 'auth_register_form.dart';

class AuthPage extends GetView<AuthController> {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final showLeftPanel = width >= AppBreakpoints.tablet;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          if (showLeftPanel) const Expanded(child: AuthLeftPanel()),
          _RightPanel(fullWidth: !showLeftPanel),
        ],
      ),
    );
  }
}

class _RightPanel extends GetView<AuthController> {
  const _RightPanel({required this.fullWidth});

  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    final formContent = Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl2),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Obx(() {
            final accentColor = controller.accentColor;
            return Theme(
              data: Theme.of(context).copyWith(
                inputDecorationTheme: Theme.of(context).inputDecorationTheme
                    .copyWith(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        borderSide: BorderSide(color: accentColor, width: 1.5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        borderSide: const BorderSide(
                          color: AppColors.error,
                          width: 1.5,
                        ),
                      ),
                    ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand header (persistent)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Déclia',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: AppColors.encre,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.or.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Bêta',
                          style: GoogleFonts.outfit(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppColors.or,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    Tr.loginBrandSubtitle.tr.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.4,
                      color: AppColors.grisTexte,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Role toggle or "Back to login" link
                  Obx(() {
                    final isRegister =
                        controller.currentView.value == AuthView.register;
                    if (isRegister) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: GestureDetector(
                          onTap: controller.goToLogin,
                          child: Row(
                            children: [
                              Icon(
                                Icons.arrow_back,
                                size: 16,
                                color: controller.accentColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                Tr.authForgotBackToLogin.tr,
                                style: GoogleFonts.outfit(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: controller.accentColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: _RoleToggle(
                          selectedIndex: controller.selectedRole.value,
                          labels: [
                            Tr.loginRoleClient.tr,
                            Tr.loginRolePhotographer.tr,
                          ],
                          icons: [
                            Icons.person_outline,
                            Icons.camera_alt_outlined,
                          ],
                          onChanged: (i) => controller.selectedRole.value = i,
                        ),
                      ),
                    );
                  }),

                  // Animated form switching
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
                        key: ValueKey(controller.currentView.value),
                        width: double.infinity,
                        child: switch (controller.currentView.value) {
                          AuthView.login => const AuthLoginForm(),
                          AuthView.register => const AuthRegisterForm(),
                          AuthView.forgotPassword =>
                            const AuthForgotPasswordForm(),
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );

    if (fullWidth) {
      return Expanded(
        child: Container(color: Colors.white, child: formContent),
      );
    }

    return SizedBox(
      width: 560,
      child: Row(
        children: [
          Container(
            width: 3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.or,
                  AppColors.terracotta,
                  AppColors.bleuOuvert,
                ],
              ),
            ),
          ),
          Expanded(child: formContent),
        ],
      ),
    );
  }
}

class _RoleToggle extends StatelessWidget {
  const _RoleToggle({
    required this.selectedIndex,
    required this.labels,
    required this.icons,
    required this.onChanged,
  });

  final int selectedIndex;
  final List<String> labels;
  final List<IconData> icons;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Stack(
        children: [
          // Sliding pill background
          Positioned.fill(
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              alignment: selectedIndex == 0
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                heightFactor: 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Tab labels
          Row(
            children: List.generate(labels.length, (i) {
              final selected = selectedIndex == i;
              final color = selected ? AppColors.encre : AppColors.pierre;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(i),
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: color,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(icons[i], size: 15, color: color),
                              const SizedBox(width: 6),
                              Text(labels[i], textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
