import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/logger/app_logger.dart';
import '../../core/storage/local_storage.dart';
import '../../core/utils/uuid_generator.dart';
import '../../usecases/consent/params.dart';
import '../../usecases/usecase.dart';
import '../controllers/auth_state_controller.dart';
import '../controllers/cookie_consent_controller.dart';
import '../services/getx_navigation_service.dart';
import '../services/navigation_service.dart';

abstract final class PresentationInjection {
  static Future<void> init() async {
    GoogleFonts.config.allowRuntimeFetching = false;

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
        uuidGenerator: Get.find<UuidGenerator>(),
      ),
      permanent: true,
    );
    Get.find<AppLogger>().debug('Presentation services registered');

    // Pre-load all used font variants so the FontLoader is ready before
    // the first frame — eliminates FOUT on web.
    GoogleFonts.cormorantGaramond(fontWeight: FontWeight.w600);
    GoogleFonts.outfit(fontWeight: FontWeight.w400);
    GoogleFonts.outfit(fontWeight: FontWeight.w500);
    GoogleFonts.outfit(fontWeight: FontWeight.w600);
    await GoogleFonts.pendingFonts();
  }
}
