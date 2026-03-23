import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../controllers/admin_shell_controller.dart';
import '../../controllers/auth_state_controller.dart';
import '../../services/navigation_service.dart';

class AdminShellBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('AdminShellBinding: registering dependencies');
    final nav = Get.find<NavigationService>();
    Get.lazyPut<AdminShellController>(
      () => AdminShellController(
        Get.find<AuthStateController>(),
        nav,
        nav,
        Get.find<AppLogger>(),
      ),
    );
  }
}
