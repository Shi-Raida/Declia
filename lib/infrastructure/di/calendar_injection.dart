import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/repositories/repository_guard.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../usecases/calendar/fetch_calendar_sessions.dart';
import '../../usecases/calendar/params.dart';
import '../../usecases/usecase.dart';
import '../datasources/contract/calendar_data_source.dart';
import '../datasources/supabase_calendar_data_source.dart';
import '../repositories/calendar_repository_impl.dart';

abstract final class CalendarInjection {
  static void init() {
    // Data source
    Get.put<CalendarDataSource>(
      SupabaseCalendarDataSource(Supabase.instance.client),
      permanent: true,
    );

    // Repository
    Get.put<CalendarRepository>(
      CalendarRepositoryImpl(
        dataSource: Get.find<CalendarDataSource>(),
        guard: Get.find<RepositoryGuard>(),
      ),
      permanent: true,
    );

    // Use case
    Get.lazyPut<UseCase<List<CalendarEvent>, FetchCalendarSessionsParams>>(
      () => FetchCalendarSessions(Get.find<CalendarRepository>()),
      fenix: true,
    );
  }
}
