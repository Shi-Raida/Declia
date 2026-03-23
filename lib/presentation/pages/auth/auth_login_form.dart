import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controllers/login_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/animated_error_banner.dart';
import '../../widgets/staggered_fade_slide_column.dart';

class AuthLoginForm extends GetView<LoginController> {
  const AuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final accentColor = controller.accentColor;
      final isClient = controller.selectedRole.value == 0;

      return Form(
        key: controller.formKey,
        child: StaggeredFadeSlideColumn(
          children: [
            // Role-dependent title + subtitle
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              layoutBuilder: (currentChild, previousChildren) => Stack(
                alignment: Alignment.topLeft,
                children: [...previousChildren, ?currentChild],
              ),
              child: SizedBox(
                key: ValueKey('login_title_${controller.selectedRole.value}'),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isClient
                          ? Tr.loginTitleClient.tr
                          : Tr.loginTitlePhotographer.tr,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: AppColors.encre,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isClient
                          ? Tr.loginSubtitleClient.tr
                          : Tr.loginSubtitlePhotographer.tr,
                      style: AppTypography.bodySmall(),
                    ),
                  ],
                ),
              ),
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
            ),
            const SizedBox(height: AppSpacing.md),

            // Password field
            Text(
              Tr.loginPassword.tr.toUpperCase(),
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
              child: Obx(
                () => TextFormField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => controller.login(),
                  decoration: InputDecoration(
                    hintText: '••••••••',
                    prefixIcon: const Icon(Icons.lock_outline, size: 18),
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
                    return null;
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Remember me + Forgot password
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    value: controller.rememberMe.value,
                    onChanged: (v) => controller.rememberMe.value = v ?? false,
                    activeColor: accentColor,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const SizedBox(width: 4),
                Text(Tr.loginRememberMe.tr, style: AppTypography.bodySmall()),
                const Spacer(),
                TextButton(
                  onPressed: controller.goToForgotPassword,
                  style: TextButton.styleFrom(
                    foregroundColor: accentColor,
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    Tr.loginForgotPassword.tr,
                    style: AppTypography.bodySmall().copyWith(
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.login,
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
                          isClient
                              ? Tr.loginSubmit.tr
                              : Tr.loginSubmitPhotographer.tr,
                          style: AppTypography.button().copyWith(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Footer registration link
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Tr.loginFooterNoAccount.tr,
                  style: AppTypography.bodySmall(),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: controller.goToRegister,
                  child: Text(
                    isClient
                        ? Tr.loginFooterCreateAccount.tr
                        : Tr.loginFooterCreateAccountPhotographer.tr,
                    style: AppTypography.bodySmall().copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
