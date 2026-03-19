import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/logger/app_logger.dart';
import 'package:declia/core/repositories/repository_guard.dart';
import 'package:declia/core/storage/local_storage.dart';
import 'package:declia/core/utils/paged_result.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/app_user.dart';
import 'package:declia/domain/entities/availability_rule.dart';
import 'package:declia/domain/entities/calendar_event.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/domain/entities/client_history.dart';
import 'package:declia/domain/entities/client_summary_stats.dart';
import 'package:declia/domain/repositories/auth_repository.dart';
import 'package:declia/domain/repositories/availability_repository.dart';
import 'package:declia/domain/repositories/calendar_repository.dart';
import 'package:declia/domain/repositories/client_history_repository.dart';
import 'package:declia/domain/repositories/client_repository.dart';
import 'package:declia/domain/repositories/consent_repository.dart';
import 'package:declia/domain/repositories/tenant_repository.dart';
import 'package:declia/infrastructure/datasources/contract/auth_data_source.dart';
import 'package:declia/infrastructure/datasources/contract/availability_data_source.dart';
import 'package:declia/infrastructure/datasources/contract/calendar_data_source.dart';
import 'package:declia/infrastructure/datasources/contract/client_data_source.dart';
import 'package:declia/infrastructure/datasources/contract/client_history_data_source.dart';
import 'package:declia/infrastructure/datasources/contract/consent_data_source.dart';
import 'package:declia/infrastructure/datasources/contract/tenant_data_source.dart';
import 'package:declia/presentation/services/navigation_service.dart';
import 'package:declia/usecases/auth/params.dart';
import 'package:declia/usecases/availability/params.dart';
import 'package:declia/usecases/calendar/params.dart';
import 'package:declia/usecases/client/params.dart';
import 'package:declia/usecases/client_history/params.dart';
import 'package:declia/usecases/consent/params.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTenantRepository extends Mock implements TenantRepository {}

class MockConsentRepository extends Mock implements ConsentRepository {}

class MockClientRepository extends Mock implements ClientRepository {}

class MockClientHistoryRepository extends Mock
    implements ClientHistoryRepository {}

class MockClientHistoryDataSource extends Mock
    implements ClientHistoryDataSource {}

class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockTenantDataSource extends Mock implements TenantDataSource {}

class MockConsentDataSource extends Mock implements ConsentDataSource {}

class MockClientDataSource extends Mock implements ClientDataSource {}

class MockLocalStorage extends Mock implements LocalStorage {}

class MockNavigationService extends Mock implements NavigationService {}

// Use cases mocked against the abstract UseCase interface (concrete classes are final)
class MockSignIn extends Mock implements UseCase<AppUser, SignInParams> {}

class MockSignOut extends Mock implements UseCase<void, NoParams> {}

class MockGetCurrentUser extends Mock implements UseCase<AppUser?, NoParams> {}

class MockSignUp extends Mock implements UseCase<void, SignUpParams> {}

class MockResetPassword extends Mock
    implements UseCase<void, ResetPasswordParams> {}

class MockSaveCookieConsent extends Mock
    implements UseCase<void, SaveCookieConsentParams> {}

class MockFetchClients extends Mock
    implements UseCase<List<Client>, NoParams> {}

class MockGetClient extends Mock implements UseCase<Client, GetClientParams> {}

class MockSaveClient extends Mock
    implements UseCase<Client, SaveClientParams> {}

class MockCreateClient extends Mock
    implements UseCase<Client, CreateClientParams> {}

class MockUpdateClient extends Mock
    implements UseCase<Client, UpdateClientParams> {}

class MockDeleteClient extends Mock
    implements UseCase<void, DeleteClientParams> {}

class MockSearchClients extends Mock
    implements UseCase<List<Client>, SearchClientsParams> {}

class MockFetchClientList extends Mock
    implements UseCase<PagedResult<Client>, FetchClientsParams> {}

class MockFetchClientHistory extends Mock
    implements UseCase<ClientHistory, FetchClientHistoryParams> {}

class MockFetchSummaryStats extends Mock
    implements
        UseCase<Map<String, ClientSummaryStats>, FetchSummaryStatsParams> {}

class MockCalendarRepository extends Mock implements CalendarRepository {}

class MockCalendarDataSource extends Mock implements CalendarDataSource {}

class MockFetchCalendarSessions extends Mock
    implements UseCase<List<CalendarEvent>, FetchCalendarSessionsParams> {}

class MockAvailabilityRepository extends Mock
    implements AvailabilityRepository {}

class MockAvailabilityDataSource extends Mock
    implements AvailabilityDataSource {}

class MockFetchAvailabilityRules extends Mock
    implements UseCase<List<AvailabilityRule>, NoParams> {}

class MockCreateAvailabilityRule extends Mock
    implements UseCase<AvailabilityRule, CreateAvailabilityRuleParams> {}

class MockUpdateAvailabilityRule extends Mock
    implements UseCase<AvailabilityRule, UpdateAvailabilityRuleParams> {}

class MockDeleteAvailabilityRule extends Mock
    implements UseCase<void, DeleteAvailabilityRuleParams> {}

/// A manual guard implementation that can be toggled between success and failure.
final class MockRepositoryGuard implements RepositoryGuard {
  bool isOnline = true;
  Failure? failureOverride;

  @override
  Future<Result<T, Failure>> call<T>(
    Future<T> Function() action, {
    required String method,
  }) async {
    if (!isOnline) {
      return const Err(NetworkFailure('No internet connection'));
    }
    if (failureOverride != null) {
      return Err(failureOverride!);
    }
    try {
      return Ok(await action());
    } on AppException catch (e) {
      return Err(Failure.fromException(e));
    }
  }
}
