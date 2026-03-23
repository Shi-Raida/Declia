import 'package:get/get.dart';

import '../../core/enums/user_role.dart';
import '../../core/errors/failures.dart';
import '../../core/logger/app_logger.dart';
import '../../usecases/auth/params.dart';
import '../models/user_view_model.dart';
import '../services/auth_navigation_service.dart';
import '../translations/translation_keys.dart';
import 'auth_failure_translator.dart';
import 'auth_orchestrator_access.dart';
import 'auth_state_controller.dart';
import 'login_form_mixin.dart';

final class LoginController extends GetxController
    with LoginFormMixin, AuthOrchestratorAccess {
  LoginController(this._signIn, this._authState, this._nav, this._logger);

  final SignInUseCase _signIn;
  final AuthStateController _authState;
  final AuthNavigationService _nav;
  final AppLogger _logger;

  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final rememberMe = true.obs;

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    final allowedRoles = selectedRoleValue == 0
        ? {UserRole.client}
        : {UserRole.photographer, UserRole.tech};

    final result = await _signIn((
      email: emailController.text.trim(),
      password: passwordController.text,
      allowedRoles: allowedRoles,
    ));
    isLoading.value = false;
    result.fold(
      ok: (user) {
        _authState.setUser(UserViewModel.fromEntity(user));
        _nav.toHome(user.role);
      },
      err: (failure) {
        _logger.warning('Login failed', error: failure);
        errorMessage.value = switch (failure) {
          UnauthorisedRoleFailure() => Tr.loginUnauthorizedRole.tr,
          InvalidCredentialsFailure() => Tr.loginInvalidCredentials.tr,
          _ => translateAuthFailure(failure),
        };
      },
    );
  }
}
