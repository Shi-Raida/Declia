import 'package:get/get.dart';

import '../../../domain/entities/app_user.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/auth_state_controller.dart';
import '../../controllers/home_controller.dart';
import '../../services/navigation_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(
        Get.find<UseCase<AppUser?, NoParams>>(),
        Get.find<AuthStateController>(),
        Get.find<NavigationService>(),
      ),
    );
  }
}
