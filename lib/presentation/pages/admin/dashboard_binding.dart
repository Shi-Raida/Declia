import 'package:get/get.dart';

import '../../controllers/auth_state_controller.dart';
import '../../controllers/dashboard_controller.dart';
import '../../services/navigation_service.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(
        Get.find<AuthStateController>(),
        Get.find<NavigationService>(),
      ),
    );
  }
}
