import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../usecases/auth/params.dart';
import '../../../usecases/tenant/params.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/auth_state_controller.dart';
import '../../routes/app_routes.dart';
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

    Get.lazyPut<AuthController>(
      () => AuthController(
        Get.find<SignInUseCase>(),
        Get.find<UseCase<void, SignUpParams>>(),
        Get.find<UseCase<void, ResetPasswordParams>>(),
        Get.find<UseCase<bool, CheckTenantSlugParams>>(),
        Get.find<AuthStateController>(),
        Get.find<NavigationService>(),
        Get.find<AppLogger>(),
        initialReason: initialViewArg is String ? initialViewArg : null,
        initialView: initialView,
        initialTenantSlug: tenantSlug,
      ),
      fenix: true,
    );
  }
}
