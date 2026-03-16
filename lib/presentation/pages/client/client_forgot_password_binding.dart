import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../usecases/auth/params.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/forgot_password_controller.dart';
import '../../services/navigation_service.dart';

class ClientForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace(
      'ClientForgotPasswordBinding: registering dependencies',
    );
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(
        Get.find<UseCase<void, ResetPasswordParams>>(),
        Get.find<AppLogger>(),
        Get.find<NavigationService>(),
      ),
      fenix: true,
    );
  }
}
