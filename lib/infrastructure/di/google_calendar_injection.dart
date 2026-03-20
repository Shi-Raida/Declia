import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/repositories/repository_guard.dart';
import '../../domain/entities/external_calendar_event.dart';
import '../../domain/entities/google_calendar_connection.dart';
import '../../domain/repositories/google_calendar_repository.dart';
import '../../usecases/google_calendar/disconnect_google_calendar.dart';
import '../../usecases/google_calendar/exchange_google_code.dart';
import '../../usecases/google_calendar/fetch_external_events.dart';
import '../../usecases/google_calendar/get_google_auth_url.dart';
import '../../usecases/google_calendar/get_google_connection_status.dart';
import '../../usecases/google_calendar/params.dart';
import '../../usecases/google_calendar/toggle_google_sync.dart';
import '../../usecases/google_calendar/trigger_google_sync.dart';
import '../../usecases/usecase.dart';
import '../datasources/contract/google_calendar_data_source.dart';
import '../datasources/supabase_google_calendar_data_source.dart';
import '../repositories/google_calendar_repository_impl.dart';

abstract final class GoogleCalendarInjection {
  static void init() {
    // Data source
    Get.put<GoogleCalendarDataSource>(
      SupabaseGoogleCalendarDataSource(Supabase.instance.client),
      permanent: true,
    );

    // Repository
    Get.put<GoogleCalendarRepository>(
      GoogleCalendarRepositoryImpl(
        dataSource: Get.find<GoogleCalendarDataSource>(),
        guard: Get.find<RepositoryGuard>(),
      ),
      permanent: true,
    );

    // Use cases
    Get.lazyPut<UseCase<String, NoParams>>(
      () => GetGoogleAuthUrl(Get.find<GoogleCalendarRepository>()),
      tag: 'getGoogleAuthUrl',
      fenix: true,
    );
    Get.lazyPut<UseCase<void, ExchangeCodeParams>>(
      () => ExchangeGoogleCode(Get.find<GoogleCalendarRepository>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<void, NoParams>>(
      () => DisconnectGoogleCalendar(Get.find<GoogleCalendarRepository>()),
      tag: 'disconnectGoogleCalendar',
      fenix: true,
    );
    Get.lazyPut<UseCase<GoogleCalendarConnection?, NoParams>>(
      () => GetGoogleConnectionStatus(Get.find<GoogleCalendarRepository>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<void, ToggleSyncParams>>(
      () => ToggleGoogleSync(Get.find<GoogleCalendarRepository>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<void, NoParams>>(
      () => TriggerGoogleSync(Get.find<GoogleCalendarRepository>()),
      tag: 'triggerGoogleSync',
      fenix: true,
    );
    Get.lazyPut<
      UseCase<List<ExternalCalendarEvent>, FetchExternalEventsParams>
    >(
      () => FetchExternalEvents(Get.find<GoogleCalendarRepository>()),
      fenix: true,
    );
  }
}
