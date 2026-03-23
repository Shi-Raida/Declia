import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

mixin AuthOrchestratorAccess {
  AuthController get orchestrator => Get.find<AuthController>();

  Color get accentColor => orchestrator.accentColor;
  RxInt get selectedRole => orchestrator.selectedRole;
  int get selectedRoleValue => orchestrator.selectedRole.value;
  void goToLogin() => orchestrator.goToLogin();
  void goToRegister() => orchestrator.goToRegister();
  void goToForgotPassword() => orchestrator.goToForgotPassword();
}
