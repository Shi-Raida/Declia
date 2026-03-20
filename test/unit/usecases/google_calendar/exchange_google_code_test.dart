import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/external_calendar_event.dart';
import 'package:declia/domain/entities/google_calendar_connection.dart';
import 'package:declia/domain/repositories/google_calendar_repository.dart';
import 'package:declia/usecases/google_calendar/exchange_google_code.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeGoogleCalendarRepository implements GoogleCalendarRepository {
  String? receivedCode;
  Failure? failureToReturn;

  @override
  Future<Result<void, Failure>> exchangeCode(String code) async {
    receivedCode = code;
    if (failureToReturn != null) return Err(failureToReturn!);
    return const Ok(null);
  }

  @override
  Future<Result<String, Failure>> getAuthUrl() async => const Ok('');
  @override
  Future<Result<void, Failure>> disconnect() async => const Ok(null);
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
  group('ExchangeGoogleCode', () {
    test('passes code to repository', () async {
      final repo = _FakeGoogleCalendarRepository();
      final useCase = ExchangeGoogleCode(repo);

      final result = await useCase((code: 'auth-code-xyz'));

      expect(result.isOk, isTrue);
      expect(repo.receivedCode, 'auth-code-xyz');
    });

    test('propagates failure', () async {
      final repo = _FakeGoogleCalendarRepository()
        ..failureToReturn = const RepositoryFailure('invalid code');
      final useCase = ExchangeGoogleCode(repo);

      final result = await useCase((code: 'bad-code'));

      expect(result.isOk, isFalse);
      result.fold(
        ok: (_) => fail('expected error'),
        err: (f) => expect(f.message, 'invalid code'),
      );
    });
  });
}
