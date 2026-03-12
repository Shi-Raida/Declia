import 'package:get/get.dart';

import '../../usecases/usecase.dart';
import '../controllers/auth_state_controller.dart';
import '../services/getx_navigation_service.dart';
import '../services/navigation_service.dart';

abstract final class PresentationInjection {
  static void init() {
    Get.put<NavigationService>(GetxNavigationService(), permanent: true);
    Get.put<AuthStateController>(
      AuthStateController(Get.find<UseCase<void, NoParams>>()),
      permanent: true,
    );
  }
}
