import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../domain/entities/app_user.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/auth_state_controller.dart';
import '../../controllers/home_controller.dart';
import '../../services/navigation_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('HomeBinding: registering dependencies');
    Get.put<HomeController>(
      HomeController(
        Get.find<UseCase<AppUser?, NoParams>>(),
        Get.find<AuthStateController>(),
        Get.find<NavigationService>(),
        Get.find<AppLogger>(),
      ),
    );
  }
}
