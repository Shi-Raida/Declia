import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../domain/entities/calendar_event.dart';
import '../../../usecases/calendar/params.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/planning_controller.dart';
import '../../services/navigation_service.dart';

class PlanningBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace(
      'PlanningBinding: registering dependencies',
    );
    Get.put<PlanningController>(
      PlanningController(
        Get.find<UseCase<List<CalendarEvent>, FetchCalendarSessionsParams>>(),
        Get.find<NavigationService>(),
      ),
    );
  }
}
