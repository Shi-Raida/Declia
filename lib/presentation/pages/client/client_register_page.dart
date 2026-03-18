import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/client_register_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class ClientRegisterPage extends GetView<ClientRegisterController> {
  const ClientRegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Obx(() {
              if (controller.isValidatingSlug.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.isSlugValid.value == false) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Tr.appName.tr,
                      style: AppTypography.heading1().copyWith(
                        color: AppColors.crepuscule,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl2),
                    const Icon(
                      Icons.link_off,
                      size: 48,
                      color: AppColors.error,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      Tr.clientRegisterInvalidLink.tr,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge().copyWith(
                        color: AppColors.pierre,
                      ),
                    ),
                  ],
                );
              }
              if (controller.isSuccess.value) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Tr.appName.tr,
                      style: AppTypography.heading1().copyWith(
                        color: AppColors.crepuscule,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl2),
                    const Icon(
                      Icons.mark_email_read_outlined,
                      size: 48,
                      color: AppColors.success,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      Tr.clientRegisterSuccess.tr,
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge().copyWith(
                        color: AppColors.crepuscule,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    TextButton(
                      onPressed: controller.goToLogin,
                      child: Text(Tr.clientRegisterHaveAccount.tr),
                    ),
                  ],
                );
              }
              return Form(
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
                      Tr.clientRegisterTitle.tr,
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
                        textInputAction: TextInputAction.next,
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
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: controller.confirmPasswordController,
                      obscureText: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => controller.register(),
                      decoration: InputDecoration(
                        labelText: Tr.clientRegisterConfirmPassword.tr,
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
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      width: double.infinity,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.register,
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(Tr.clientRegisterSubmit.tr),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextButton(
                      onPressed: controller.goToLogin,
                      child: Text(Tr.clientRegisterHaveAccount.tr),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
