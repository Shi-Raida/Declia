import 'package:get/get.dart';

import '../../../domain/entities/app_user.dart';
import '../../../usecases/auth/sign_in.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/auth_state_controller.dart';
import '../../controllers/login_controller.dart';
import '../../services/navigation_service.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(
        Get.find<UseCase<AppUser, SignInParams>>(),
        Get.find<AuthStateController>(),
        Get.find<NavigationService>(),
      ),
    );
  }
}
