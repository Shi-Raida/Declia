import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/external_calendar_event.dart';
import 'package:declia/domain/entities/google_calendar_connection.dart';
import 'package:declia/domain/repositories/google_calendar_repository.dart';
import 'package:declia/usecases/google_calendar/toggle_google_sync.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeGoogleCalendarRepository implements GoogleCalendarRepository {
  String? lastIdValue;
  bool? lastEnabledValue;
  Failure? failureToReturn;

  @override
  Future<Result<void, Failure>> toggleSync({
    required String id,
    required bool enabled,
  }) async {
    lastIdValue = id;
    lastEnabledValue = enabled;
    if (failureToReturn != null) return Err(failureToReturn!);
    return const Ok(null);
  }

  @override
  Future<Result<String, Failure>> getAuthUrl() async => const Ok('');
  @override
  Future<Result<void, Failure>> exchangeCode(String code) async =>
      const Ok(null);
  @override
  Future<Result<void, Failure>> disconnect() async => const Ok(null);
  @override
  Future<Result<GoogleCalendarConnection?, Failure>>
  getConnectionStatus() async => const Ok(null);
  @override
  Future<Result<void, Failure>> triggerSync() async => const Ok(null);
  @override
  Future<Result<List<ExternalCalendarEvent>, Failure>> fetchExternalEvents({
    required DateTime start,
    required DateTime end,
  }) async => const Ok([]);
}

void main() {
  group('ToggleGoogleSync', () {
    test('passes id and enabled=true to repository', () async {
      final repo = _FakeGoogleCalendarRepository();
      final useCase = ToggleGoogleSync(repo);

      final result = await useCase((id: 'conn-1', enabled: true));

      expect(result.isOk, isTrue);
      expect(repo.lastIdValue, 'conn-1');
      expect(repo.lastEnabledValue, isTrue);
    });

    test('passes id and enabled=false to repository', () async {
      final repo = _FakeGoogleCalendarRepository();
      final useCase = ToggleGoogleSync(repo);

      final result = await useCase((id: 'conn-1', enabled: false));

      expect(result.isOk, isTrue);
      expect(repo.lastEnabledValue, isFalse);
    });

    test('propagates failure', () async {
      final repo = _FakeGoogleCalendarRepository()
        ..failureToReturn = const RepositoryFailure('toggle error');
      final useCase = ToggleGoogleSync(repo);

      final result = await useCase((id: 'conn-1', enabled: true));

      expect(result.isOk, isFalse);
    });
  });
}
