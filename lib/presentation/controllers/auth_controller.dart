import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../routes/route_args.dart';
import '../theme/app_colors.dart';
import '../translations/translation_keys.dart';
import 'auth_state_controller.dart';
import 'forgot_password_controller.dart';
import 'login_controller.dart';
import 'register_controller.dart';

enum AuthView { login, register, forgotPassword }

final class AuthController extends GetxController {
  AuthController(
    this._authState,
    this._login,
    this._register,
    this._forgotPassword, {
    this.initialReason,
    AuthView initialView = AuthView.login,
  }) : currentView = initialView.obs;

  final AuthStateController _authState;
  final LoginController _login;
  final RegisterController _register;
  final ForgotPasswordController _forgotPassword;
  final String? initialReason;

  // View state
  final Rx<AuthView> currentView;
  final selectedRole = 0.obs; // 0=Client, 1=Photographer

  Color get accentColor =>
      selectedRole.value == 0 ? AppColors.bleuOuvert : AppColors.terracotta;

  // Delegation getters for AuthLeftPanel
  int get registerStepValue => _register.registerStep.value;
  int get totalSteps => _register.totalSteps;

  @override
  void onInit() {
    super.onInit();
    if (initialReason == RouteArgs.unauthorizedRole) {
      _authState.signOut();
      _login.errorMessage.value = Tr.auth.login.unauthorizedRole.tr;
    }
  }

  // -- View navigation --

  void goToRegister() {
    _register.errorMessage.value = null;
    _register.isRegisterSuccess.value = false;
    _register.registerStep.value = 0;
    currentView.value = AuthView.register;
    _replaceUrl(AppRoutes.authRegister);
  }

  void goToForgotPassword() {
    _forgotPassword.errorMessage.value = null;
    _forgotPassword.isForgotSuccess.value = false;
    _forgotPassword.forgotEmailController.text = _login.emailController.text;
    currentView.value = AuthView.forgotPassword;
    _replaceUrl(AppRoutes.authForgotPassword);
  }

  void goToLogin() {
    _login.errorMessage.value = null;
    currentView.value = AuthView.login;
    _replaceUrl(AppRoutes.login);
  }

  void _replaceUrl(String path) {
    SystemNavigator.routeInformationUpdated(
      uri: Uri.parse(path),
      replace: true,
    );
  }
}
