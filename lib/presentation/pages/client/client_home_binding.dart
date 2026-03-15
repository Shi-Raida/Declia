import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../controllers/auth_state_controller.dart';
import '../../controllers/client_home_controller.dart';
import '../../services/navigation_service.dart';

class ClientHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('ClientHomeBinding: registering dependencies');
    Get.lazyPut<ClientHomeController>(
      () => ClientHomeController(
        Get.find<AuthStateController>(),
        Get.find<NavigationService>(),
        Get.find<AppLogger>(),
      ),
    );
  }
}
