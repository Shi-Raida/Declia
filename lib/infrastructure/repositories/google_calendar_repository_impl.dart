import '../../core/errors/failures.dart';
import '../../core/repositories/repository_guard.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/external_calendar_event.dart';
import '../../domain/entities/google_calendar_connection.dart';
import '../../domain/repositories/google_calendar_repository.dart';
import '../datasources/contract/google_calendar_data_source.dart';

final class GoogleCalendarRepositoryImpl implements GoogleCalendarRepository {
  const GoogleCalendarRepositoryImpl({
    required GoogleCalendarDataSource dataSource,
    required RepositoryGuard guard,
  }) : _dataSource = dataSource,
       _guard = guard;

  final GoogleCalendarDataSource _dataSource;
  final RepositoryGuard _guard;

  @override
  Future<Result<String, Failure>> getAuthUrl() =>
      _guard(() => _dataSource.getAuthUrl(), method: 'getAuthUrl');

  @override
  Future<Result<void, Failure>> exchangeCode(String code) =>
      _guard(() => _dataSource.exchangeCode(code), method: 'exchangeCode');

  @override
  Future<Result<void, Failure>> disconnect() =>
      _guard(() => _dataSource.disconnect(), method: 'disconnect');

  @override
  Future<Result<GoogleCalendarConnection?, Failure>> getConnectionStatus() =>
      _guard(
        () => _dataSource.getConnectionStatus(),
        method: 'getConnectionStatus',
      );

  @override
  Future<Result<void, Failure>> toggleSync({required String id, required bool enabled}) =>
      _guard(
        () => _dataSource.toggleSync(id: id, enabled: enabled),
        method: 'toggleSync',
      );

  @override
  Future<Result<void, Failure>> triggerSync() =>
      _guard(() => _dataSource.triggerSync(), method: 'triggerSync');

  @override
  Future<Result<List<ExternalCalendarEvent>, Failure>> fetchExternalEvents({
    required DateTime start,
    required DateTime end,
  }) => _guard(
    () => _dataSource.fetchExternalEvents(start: start, end: end),
    method: 'fetchExternalEvents',
  );
}
