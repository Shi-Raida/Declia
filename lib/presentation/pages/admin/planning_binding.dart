import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../core/utils/clock.dart';
import '../../../domain/entities/availability_rule.dart';
import '../../../domain/entities/calendar_event.dart';
import '../../../domain/entities/external_calendar_event.dart';
import '../../../usecases/availability/params.dart';
import '../../../usecases/calendar/params.dart';
import '../../../usecases/google_calendar/params.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/availability_controller.dart';
import '../../controllers/planning_controller.dart';
import '../../services/navigation_service.dart';

class PlanningBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('PlanningBinding: registering dependencies');
    Get.put<AvailabilityController>(
      AvailabilityController(
        Get.find<UseCase<List<AvailabilityRule>, NoParams>>(),
        Get.find<UseCase<AvailabilityRule, CreateAvailabilityRuleParams>>(
          tag: 'createAvailabilityRule',
        ),
        Get.find<UseCase<AvailabilityRule, UpdateAvailabilityRuleParams>>(
          tag: 'updateAvailabilityRule',
        ),
        Get.find<UseCase<void, DeleteAvailabilityRuleParams>>(),
      ),
    );
    Get.put<PlanningController>(
      PlanningController(
        Get.find<UseCase<List<CalendarEvent>, FetchCalendarSessionsParams>>(),
        Get.find<NavigationService>(),
        Get.find<
          UseCase<List<ExternalCalendarEvent>, FetchExternalEventsParams>
        >(),
        Get.find<Clock>(),
      ),
    );
  }
}
