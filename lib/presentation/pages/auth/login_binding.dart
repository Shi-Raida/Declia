import 'package:get/get.dart';

import '../../../core/enums/user_role.dart';
import '../../../core/logger/app_logger.dart';
import '../../../domain/entities/app_user.dart';
import '../../../usecases/auth/params.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/auth_state_controller.dart';
import '../../controllers/login_controller.dart';
import '../../services/navigation_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('LoginBinding: registering dependencies');
    Get.lazyPut<LoginController>(
      () => LoginController(
        Get.find<UseCase<AppUser, SignInParams>>(),
        Get.find<AuthStateController>(),
        Get.find<AppLogger>(),
        {UserRole.photographer, UserRole.tech},
        () => Get.find<NavigationService>().toDashboard(),
        initialReason: Get.arguments as String?,
      ),
      fenix: true,
    );
  }
}
