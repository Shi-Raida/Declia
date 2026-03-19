import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../domain/entities/google_calendar_connection.dart';
import '../../../usecases/google_calendar/params.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('SettingsBinding: registering dependencies');
    Get.put<SettingsController>(
      SettingsController(
        Get.find<UseCase<String, NoParams>>(tag: 'getGoogleAuthUrl'),
        Get.find<UseCase<void, ExchangeCodeParams>>(),
        Get.find<UseCase<void, NoParams>>(tag: 'disconnectGoogleCalendar'),
        Get.find<UseCase<GoogleCalendarConnection?, NoParams>>(),
        Get.find<UseCase<void, ToggleSyncParams>>(),
        Get.find<UseCase<void, NoParams>>(tag: 'triggerGoogleSync'),
      ),
    );
  }
}
