import 'package:get/get.dart';

import '../../core/errors/app_exception.dart';
import '../../domain/entities/app_user.dart';
import '../../usecases/auth/auth_params.dart';
import '../../usecases/usecase.dart';
import '../services/navigation_service.dart';
import 'auth_state_controller.dart';
import 'login_form_mixin.dart';

class LoginController extends GetxController with LoginFormMixin {
  LoginController(this._signIn, this._authState, this._nav);

  final UseCase<AppUser, SignInParams> _signIn;
  final AuthStateController _authState;
  final NavigationService _nav;

  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments == 'unauthorized_role') {
      errorMessage.value = 'Accès réservé aux photographes';
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
      _authState.setUser(user);
      _nav.toDashboard();
    } on InvalidCredentialsException {
      errorMessage.value = 'Email ou mot de passe incorrect';
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }
}
