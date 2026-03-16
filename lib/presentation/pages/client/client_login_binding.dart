import 'package:get/get.dart';

import '../../../core/enums/user_role.dart';
import '../../../core/logger/app_logger.dart';
import '../../../usecases/auth/sign_in.dart';
import '../../controllers/auth_state_controller.dart';
import '../../controllers/login_controller.dart';
import '../../services/navigation_service.dart';

class ClientLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('ClientLoginBinding: registering dependencies');
    Get.lazyPut<LoginController>(
      () => LoginController(
        Get.find<SignInUseCase>(),
        Get.find<AuthStateController>(),
        Get.find<AppLogger>(),
        {UserRole.client},
        () => Get.find<NavigationService>().toClientHome(),
        initialReason: Get.arguments as String?,
        onForgotPassword: () =>
            Get.find<NavigationService>().toClientForgotPassword(),
        onRegister: () => Get.find<NavigationService>().toClientRegister(),
      ),
      fenix: true,
    );
  }
}
