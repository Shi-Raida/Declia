import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/login_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Tr.appName.tr,
                    style: AppTypography.heading1().copyWith(
                      color: AppColors.crepuscule,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    Tr.loginSubtitle.tr,
                    style: AppTypography.bodyLarge().copyWith(
                      color: AppColors.pierre,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl2),
                  Obx(
                    () => controller.errorMessage.value != null
                        ? Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(
                              bottom: AppSpacing.md,
                            ),
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.errorLight,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.sm,
                              ),
                            ),
                            child: Text(
                              controller.errorMessage.value!,
                              style: AppTypography.bodyMedium().copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  TextFormField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: Tr.loginEmail.tr,
                      hintText: Tr.loginEmailHint.tr,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return Tr.loginEmailRequired.tr;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Obx(
                    () => TextFormField(
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => controller.login(),
                      decoration: InputDecoration(
                        labelText: Tr.loginPassword.tr,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.togglePasswordVisibility,
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
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(Tr.loginSubmit.tr),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
