import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/external_calendar_event.dart';
import 'package:declia/domain/entities/google_calendar_connection.dart';
import 'package:declia/domain/repositories/google_calendar_repository.dart';
import 'package:declia/usecases/google_calendar/disconnect_google_calendar.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeGoogleCalendarRepository implements GoogleCalendarRepository {
  bool disconnectCalled = false;
  Failure? failureToReturn;

  @override
  Future<Result<void, Failure>> disconnect() async {
    disconnectCalled = true;
    if (failureToReturn != null) return Err(failureToReturn!);
    return const Ok(null);
  }

  @override
  Future<Result<String, Failure>> getAuthUrl() async => const Ok('');
  @override
  Future<Result<void, Failure>> exchangeCode(String code) async =>
      const Ok(null);
  @override
  Future<Result<GoogleCalendarConnection?, Failure>>
  getConnectionStatus() async => const Ok(null);
  @override
  Future<Result<void, Failure>> toggleSync({
    required String id,
    required bool enabled,
  }) async => const Ok(null);
  @override
  Future<Result<void, Failure>> triggerSync() async => const Ok(null);
  @override
  Future<Result<List<ExternalCalendarEvent>, Failure>> fetchExternalEvents({
    required DateTime start,
    required DateTime end,
  }) async => const Ok([]);
}

void main() {
  group('DisconnectGoogleCalendar', () {
    test('calls disconnect on repository', () async {
      final repo = _FakeGoogleCalendarRepository();
      final useCase = DisconnectGoogleCalendar(repo);

      final result = await useCase(const NoParams());

      expect(result.isOk, isTrue);
      expect(repo.disconnectCalled, isTrue);
    });

    test('propagates failure', () async {
      final repo = _FakeGoogleCalendarRepository()
        ..failureToReturn = const RepositoryFailure('disconnect error');
      final useCase = DisconnectGoogleCalendar(repo);

      final result = await useCase(const NoParams());

      expect(result.isOk, isFalse);
    });
  });
}
