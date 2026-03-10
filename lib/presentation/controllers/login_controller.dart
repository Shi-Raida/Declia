import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/errors/app_exception.dart';
import '../../usecases/auth/sign_in.dart';
import '../routes/app_routes.dart';
import 'auth_state_controller.dart';

class LoginController extends GetxController {
  LoginController(this._signIn);

  final SignIn _signIn;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final isPasswordVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments == 'unauthorized_role') {
      errorMessage.value = 'Accès réservé aux photographes';
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    try {
      final user = await _signIn((
        email: emailController.text.trim(),
        password: passwordController.text,
      ));
      Get.find<AuthStateController>().setUser(user);
      Get.offAllNamed(AppRoutes.adminDashboard);
    } on InvalidCredentialsException {
      errorMessage.value = 'Email ou mot de passe incorrect';
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
