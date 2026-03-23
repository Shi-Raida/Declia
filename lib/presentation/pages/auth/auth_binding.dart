import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../core/utils/clock.dart';
import '../../../usecases/auth/params.dart';
import '../../../usecases/tenant/params.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/auth_state_controller.dart';
import '../../controllers/forgot_password_controller.dart';
import '../../controllers/login_controller.dart';
import '../../controllers/register_controller.dart';
import '../../routes/app_routes.dart';
import '../../services/default_image_picker_service.dart';
import '../../services/image_picker_service.dart';
import '../../services/navigation_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('AuthBinding: registering dependencies');

    final initialViewArg = Get.arguments;

    // Determine initial view from arguments or current route
    AuthView initialView;
    if (initialViewArg is AuthView) {
      initialView = initialViewArg;
    } else if (Get.currentRoute.startsWith(AppRoutes.authRegister)) {
      initialView = AuthView.register;
    } else if (Get.currentRoute.startsWith(AppRoutes.authForgotPassword)) {
      initialView = AuthView.forgotPassword;
    } else {
      initialView = AuthView.login;
    }

    final tenantSlug = Get.parameters['tenant'];

    if (!Get.isRegistered<ImagePickerService>()) {
      Get.put<ImagePickerService>(const DefaultImagePickerService());
    }

    // Sub-controllers first (AuthController depends on them)
    Get.lazyPut<LoginController>(
      () => LoginController(
        Get.find<SignInUseCase>(),
        Get.find<AuthStateController>(),
        Get.find<NavigationService>(),
        Get.find<AppLogger>(),
      ),
      fenix: true,
    );

    Get.lazyPut<RegisterController>(
      () => RegisterController(
        Get.find<UseCase<void, SignUpParams>>(),
        Get.find<UseCase<bool, CheckTenantSlugParams>>(),
        Get.find<AppLogger>(),
        Get.find<ImagePickerService>(),
        Get.find<Clock>(),
        initialTenantSlug: tenantSlug,
      ),
      fenix: true,
    );

    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(
        Get.find<UseCase<void, ResetPasswordParams>>(),
        Get.find<AppLogger>(),
      ),
      fenix: true,
    );

    // Orchestrator last (depends on sub-controllers)
    Get.lazyPut<AuthController>(
      () => AuthController(
        Get.find<AuthStateController>(),
        Get.find<LoginController>(),
        Get.find<RegisterController>(),
        Get.find<ForgotPasswordController>(),
        initialReason: initialViewArg is String ? initialViewArg : null,
        initialView: initialView,
      ),
      fenix: true,
    );
  }
}
