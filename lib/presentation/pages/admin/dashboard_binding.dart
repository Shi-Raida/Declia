import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../controllers/auth_state_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../services/navigation_service.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('DashboardBinding: registering dependencies');
    Get.lazyPut<DashboardController>(
      () => DashboardController(
        Get.find<AuthStateController>(),
        Get.find<NavigationService>(),
        Get.find<AppLogger>(),
      ),
    );
  }
}
