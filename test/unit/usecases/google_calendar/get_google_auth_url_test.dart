import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/external_calendar_event.dart';
import 'package:declia/domain/entities/google_calendar_connection.dart';
import 'package:declia/domain/repositories/google_calendar_repository.dart';
import 'package:declia/usecases/google_calendar/get_google_auth_url.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeGoogleCalendarRepository implements GoogleCalendarRepository {
  String? urlToReturn;
  Failure? failureToReturn;

  @override
  Future<Result<String, Failure>> getAuthUrl() async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(urlToReturn ?? 'https://accounts.google.com/auth');
  }

  @override
  Future<Result<void, Failure>> exchangeCode(String code) async => const Ok(null);
  @override
  Future<Result<void, Failure>> disconnect() async => const Ok(null);
  @override
  Future<Result<GoogleCalendarConnection?, Failure>> getConnectionStatus() async => const Ok(null);
  @override
  Future<Result<void, Failure>> toggleSync({required String id, required bool enabled}) async => const Ok(null);
  @override
  Future<Result<void, Failure>> triggerSync() async => const Ok(null);
  @override
  Future<Result<List<ExternalCalendarEvent>, Failure>> fetchExternalEvents({
    required DateTime start,
    required DateTime end,
  }) async => const Ok([]);
}

void main() {
  group('GetGoogleAuthUrl', () {
    test('returns URL from repository', () async {
      final repo = _FakeGoogleCalendarRepository()
        ..urlToReturn = 'https://accounts.google.com/auth?client_id=123';
      final useCase = GetGoogleAuthUrl(repo);

      final result = await useCase(const NoParams());

      expect(result.isOk, isTrue);
      result.fold(
        ok: (url) => expect(url, contains('accounts.google.com')),
        err: (_) => fail('expected ok'),
      );
    });

    test('propagates failure from repository', () async {
      final repo = _FakeGoogleCalendarRepository()
        ..failureToReturn = const RepositoryFailure('network error');
      final useCase = GetGoogleAuthUrl(repo);

      final result = await useCase(const NoParams());

      expect(result.isOk, isFalse);
      result.fold(
        ok: (_) => fail('expected error'),
        err: (f) => expect(f.message, 'network error'),
      );
    });
  });
}
