import 'package:get/get.dart';

import '../../core/enums/user_role.dart';
import '../../core/errors/failures.dart';
import '../../core/logger/app_logger.dart';
import '../../domain/entities/app_user.dart';
import '../../usecases/auth/params.dart';
import '../../usecases/usecase.dart';
import '../translations/translation_keys.dart';
import '../routes/route_args.dart';
import 'auth_state_controller.dart';
import 'login_form_mixin.dart';

final class LoginController extends GetxController with LoginFormMixin {
  LoginController(
    this._signIn,
    this._authState,
    this._logger,
    this._allowedRoles,
    this._onLoginSuccess,
  );

  final UseCase<AppUser, SignInParams> _signIn;
  final AuthStateController _authState;
  final AppLogger _logger;
  final Set<UserRole> _allowedRoles;
  final void Function() _onLoginSuccess;

  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments == RouteArgs.unauthorizedRole) {
      errorMessage.value = Tr.loginUnauthorizedRole.tr;
      _authState.signOut();
    }
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    errorMessage.value = null;

    final result = await _signIn((
      email: emailController.text.trim(),
      password: passwordController.text,
      allowedRoles: _allowedRoles,
    ));
    isLoading.value = false;
    result.fold(
      ok: (user) {
        _authState.setUser(user);
        _onLoginSuccess();
      },
      err: (failure) {
        _logger.warning('Login failed', error: failure);
        errorMessage.value = switch (failure) {
          UnauthorisedRoleFailure() => Tr.loginUnauthorizedRole.tr,
          InvalidCredentialsFailure() => Tr.loginInvalidCredentials.tr,
          _ => failure.message,
        };
      },
    );
  }
}
