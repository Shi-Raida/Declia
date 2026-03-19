import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../usecases/auth/params.dart';
import '../../controllers/auth_state_controller.dart';
import '../../controllers/home_controller.dart';
import '../../services/navigation_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('HomeBinding: registering dependencies');
    Get.put<HomeController>(
      HomeController(
        Get.find<GetCurrentUserUseCase>(),
        Get.find<AuthStateController>(),
        Get.find<NavigationService>(),
        Get.find<AppLogger>(),
      ),
    );
  }
}
