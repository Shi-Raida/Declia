import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/logger/app_logger.dart';
import '../../usecases/auth/params.dart';
import '../../usecases/usecase.dart';
import 'auth_failure_translator.dart';
import 'auth_orchestrator_access.dart';

final class ForgotPasswordController extends GetxController
    with AuthOrchestratorAccess {
  ForgotPasswordController(this._resetPassword, this._logger);

  final UseCase<void, ResetPasswordParams> _resetPassword;
  final AppLogger _logger;

  final forgotFormKey = GlobalKey<FormState>();
  final forgotEmailController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final isForgotSuccess = false.obs;

  Future<void> submitForgotPassword() async {
    if (!forgotFormKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    final result = await _resetPassword((
      email: forgotEmailController.text.trim(),
    ));
    isLoading.value = false;
    result.fold(
      ok: (_) => isForgotSuccess.value = true,
      err: (failure) {
        _logger.warning('Password reset failed', error: failure);
        errorMessage.value = translateAuthFailure(failure);
      },
    );
  }

  @override
  void onClose() {
    forgotEmailController.dispose();
    super.onClose();
  }
}
