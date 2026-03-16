import 'package:get/get.dart';

import '../../core/logger/app_logger.dart';
import '../../core/storage/local_storage.dart';
import '../../usecases/consent/params.dart';
import '../../usecases/usecase.dart';
import '../controllers/auth_state_controller.dart';
import '../controllers/cookie_consent_controller.dart';
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
    Get.put<CookieConsentController>(
      CookieConsentController(
        saveCookieConsent: Get.find<UseCase<void, SaveCookieConsentParams>>(),
        localStorage: Get.find<LocalStorage>(),
        navigationService: Get.find<NavigationService>(),
      ),
      permanent: true,
    );
    Get.find<AppLogger>().debug('Presentation services registered');
  }
}
