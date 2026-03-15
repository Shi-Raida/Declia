import 'package:get/get.dart';

import '../../core/logger/app_logger.dart';
import '../../usecases/auth/params.dart';
import '../../usecases/usecase.dart';
import 'forgot_password_form_mixin.dart';

final class ForgotPasswordController extends GetxController
    with ForgotPasswordFormMixin {
  ForgotPasswordController(this._resetPassword, this._logger);

  final UseCase<void, ResetPasswordParams> _resetPassword;
  final AppLogger _logger;

  final isLoading = false.obs;
  final isSuccess = false.obs;
  final errorMessage = Rxn<String>();

  Future<void> submit() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    final result = await _resetPassword((email: emailController.text.trim()));
    isLoading.value = false;
    result.fold(
      ok: (_) => isSuccess.value = true,
      err: (failure) {
        _logger.warning('Password reset failed', error: failure);
        errorMessage.value = failure.message;
      },
    );
  }
}
