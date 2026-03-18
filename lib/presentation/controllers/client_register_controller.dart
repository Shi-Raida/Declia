import 'package:get/get.dart';

import '../../core/errors/failures.dart';
import '../../core/logger/app_logger.dart';
import '../../usecases/auth/params.dart';
import '../../usecases/tenant/check_tenant_slug.dart';
import '../../usecases/usecase.dart';
import '../services/navigation_service.dart';
import '../translations/translation_keys.dart';
import 'login_form_mixin.dart';
import 'register_form_mixin.dart';

final class ClientRegisterController extends GetxController
    with LoginFormMixin, RegisterFormMixin {
  ClientRegisterController(
    this._signUp,
    this._logger,
    this._tenantSlug,
    this._nav,
    this._checkTenantSlug,
  );

  final UseCase<void, SignUpParams> _signUp;
  final AppLogger _logger;
  final String _tenantSlug;
  final NavigationService _nav;
  final UseCase<bool, CheckTenantSlugParams> _checkTenantSlug;

  final isLoading = false.obs;
  final isSuccess = false.obs;
  final isValidatingSlug = true.obs;
  final isSlugValid = Rxn<bool>();
  final errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    _validateSlug();
  }

  Future<void> _validateSlug() async {
    if (_tenantSlug.isEmpty) {
      isSlugValid.value = false;
      isValidatingSlug.value = false;
      return;
    }
    final result = await _checkTenantSlug((slug: _tenantSlug));
    result.fold(
      ok: (exists) => isSlugValid.value = exists,
      err: (_) => isSlugValid.value = true, // fail open: let server-side be the final guard
    );
    isValidatingSlug.value = false;
  }

  void goToLogin() => _nav.toClientLogin(
    tenantSlug: _tenantSlug.isNotEmpty ? _tenantSlug : null,
  );

  Future<void> register() async {
    if (isSlugValid.value != true) {
      errorMessage.value = Tr.clientRegisterInvalidLink.tr;
      return;
    }
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
