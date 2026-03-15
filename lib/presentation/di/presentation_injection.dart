import 'package:get/get.dart';

import '../../core/logger/app_logger.dart';
import '../../usecases/usecase.dart';
import '../controllers/admin_shell_controller.dart';
import '../controllers/auth_state_controller.dart';
import '../services/getx_navigation_service.dart';
import '../services/navigation_service.dart';

abstract final class PresentationInjection {
  static void init() {
    Get.put<NavigationService>(GetxNavigationService(), permanent: true);
    Get.put<AuthStateController>(
      AuthStateController(
        Get.find<UseCase<void, NoParams>>(),
        logger: Get.find<AppLogger>(),
      ),
      permanent: true,
    );
    Get.put<AdminShellController>(
      AdminShellController(
        Get.find<AuthStateController>(),
        Get.find<NavigationService>(),
        Get.find<AppLogger>(),
      ),
      permanent: true,
    );
    Get.find<AppLogger>().debug('Presentation services registered');
  }
}
