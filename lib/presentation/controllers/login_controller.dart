import 'package:get/get.dart';

import '../../core/enums/user_role.dart';
import '../../core/errors/app_exception.dart';
import '../../domain/entities/app_user.dart';
import '../../usecases/auth/params.dart';
import '../../usecases/usecase.dart';
import '../translations/translation_keys.dart';
import '../routes/route_args.dart';
import '../services/navigation_service.dart';
import 'auth_state_controller.dart';
import 'login_form_mixin.dart';

final class LoginController extends GetxController with LoginFormMixin {
  LoginController(this._signIn, this._authState, this._nav, this._allowedRoles);

  final UseCase<AppUser, SignInParams> _signIn;
  final AuthStateController _authState;
  final NavigationService _nav;
  final Set<UserRole> _allowedRoles;

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

    try {
      final user = await _signIn((
        email: emailController.text.trim(),
        password: passwordController.text,
      ));
      if (!_allowedRoles.contains(user.role)) {
        await _authState.signOut();
        errorMessage.value = Tr.loginUnauthorizedRole.tr;
        return;
      }
      _authState.setUser(user);
      _nav.toDashboard();
    } on InvalidCredentialsException {
      errorMessage.value = Tr.loginInvalidCredentials.tr;
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }
}
