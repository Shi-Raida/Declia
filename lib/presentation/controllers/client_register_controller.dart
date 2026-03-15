import 'package:get/get.dart';

import '../../core/errors/failures.dart';
import '../../core/logger/app_logger.dart';
import '../../usecases/auth/params.dart';
import '../../usecases/usecase.dart';
import '../translations/translation_keys.dart';
import 'login_form_mixin.dart';
import 'register_form_mixin.dart';

final class ClientRegisterController extends GetxController
    with LoginFormMixin, RegisterFormMixin {
  ClientRegisterController(this._signUp, this._logger, this._tenantSlug);

  final UseCase<void, SignUpParams> _signUp;
  final AppLogger _logger;
  final String _tenantSlug;

  final isLoading = false.obs;
  final isSuccess = false.obs;
  final errorMessage = Rxn<String>();

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    final result = await _signUp((
      email: emailController.text.trim(),
      password: passwordController.text,
      tenantSlug: _tenantSlug,
    ));
    isLoading.value = false;
    result.fold(
      ok: (_) => isSuccess.value = true,
      err: (failure) {
        _logger.warning('Registration failed', error: failure);
        errorMessage.value = switch (failure) {
          EmailAlreadyInUseFailure() => Tr.clientRegisterEmailAlreadyInUse.tr,
          _ => failure.message,
        };
      },
    );
  }
}
