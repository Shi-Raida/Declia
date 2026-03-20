import 'package:declia/core/enums/google_sync_status.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/external_calendar_event.dart';
import 'package:declia/domain/entities/google_calendar_connection.dart';
import 'package:declia/domain/repositories/google_calendar_repository.dart';
import 'package:declia/presentation/controllers/settings_controller.dart';
import 'package:declia/usecases/google_calendar/params.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 21);

GoogleCalendarConnection _connection() => GoogleCalendarConnection(
  id: 'c1',
  tenantId: 'tid',
  calendarId: 'primary',
  syncEnabled: true,
  createdAt: _now,
  updatedAt: _now,
);

final class _FakeGoogleCalendarRepository implements GoogleCalendarRepository {
  String urlToReturn = 'https://accounts.google.com/auth';
  GoogleCalendarConnection? connectionToReturn;
  Failure? failureToReturn;
  bool disconnectCalled = false;
  bool triggerCalled = false;
  bool? lastEnabledValue;

  @override
  Future<Result<String, Failure>> getAuthUrl() async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(urlToReturn);
  }

  @override
  Future<Result<void, Failure>> exchangeCode(String code) async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return const Ok(null);
  }

  @override
  Future<Result<void, Failure>> disconnect() async {
    disconnectCalled = true;
    if (failureToReturn != null) return Err(failureToReturn!);
    return const Ok(null);
  }

  @override
  Future<Result<GoogleCalendarConnection?, Failure>> getConnectionStatus() async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(connectionToReturn);
  }

  @override
  Future<Result<void, Failure>> toggleSync({required String id, required bool enabled}) async {
    lastEnabledValue = enabled;
    if (failureToReturn != null) return Err(failureToReturn!);
    return const Ok(null);
  }

  @override
  Future<Result<void, Failure>> triggerSync() async {
    triggerCalled = true;
    if (failureToReturn != null) return Err(failureToReturn!);
    return const Ok(null);
  }

  @override
  Future<Result<List<ExternalCalendarEvent>, Failure>> fetchExternalEvents({
    required DateTime start,
    required DateTime end,
  }) async => const Ok([]);
}

SettingsController _makeController(_FakeGoogleCalendarRepository repo) {
  return SettingsController(
    GetGoogleAuthUrlFake(repo),
    ExchangeGoogleCodeFake(repo),
    DisconnectFake(repo),
    GetStatusFake(repo),
    ToggleSyncFake(repo),
    TriggerSyncFake(repo),
  );
}

final class GetGoogleAuthUrlFake extends UseCase<String, NoParams> {
  GetGoogleAuthUrlFake(this._repo);
  final _FakeGoogleCalendarRepository _repo;
  @override
  Future<Result<String, Failure>> call(NoParams _) => _repo.getAuthUrl();
}

final class ExchangeGoogleCodeFake extends UseCase<void, ExchangeCodeParams> {
  ExchangeGoogleCodeFake(this._repo);
  final _FakeGoogleCalendarRepository _repo;
  @override
  Future<Result<void, Failure>> call(ExchangeCodeParams p) =>
      _repo.exchangeCode(p.code);
}

final class DisconnectFake extends UseCase<void, NoParams> {
  DisconnectFake(this._repo);
  final _FakeGoogleCalendarRepository _repo;
  @override
  Future<Result<void, Failure>> call(NoParams _) => _repo.disconnect();
}

final class GetStatusFake extends UseCase<GoogleCalendarConnection?, NoParams> {
  GetStatusFake(this._repo);
  final _FakeGoogleCalendarRepository _repo;
  @override
  Future<Result<GoogleCalendarConnection?, Failure>> call(NoParams _) =>
      _repo.getConnectionStatus();
}

final class ToggleSyncFake extends UseCase<void, ToggleSyncParams> {
  ToggleSyncFake(this._repo);
  final _FakeGoogleCalendarRepository _repo;
  @override
  Future<Result<void, Failure>> call(ToggleSyncParams p) =>
      _repo.toggleSync(id: p.id, enabled: p.enabled);
}

final class TriggerSyncFake extends UseCase<void, NoParams> {
  TriggerSyncFake(this._repo);
  final _FakeGoogleCalendarRepository _repo;
  @override
  Future<Result<void, Failure>> call(NoParams _) => _repo.triggerSync();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsController', () {
    group('loadConnectionStatus', () {
      test('sets connected status when connection exists', () async {
        final repo = _FakeGoogleCalendarRepository()
          ..connectionToReturn = _connection();
        final controller = _makeController(repo);

        await controller.loadConnectionStatus();

        expect(controller.connection.value, isNotNull);
        expect(controller.syncStatus.value, GoogleSyncStatus.connected);
        expect(controller.isLoading.value, isFalse);
      });

      test('sets disconnected when no connection', () async {
        final repo = _FakeGoogleCalendarRepository();
        final controller = _makeController(repo);

        await controller.loadConnectionStatus();

        expect(controller.connection.value, isNull);
        expect(controller.syncStatus.value, GoogleSyncStatus.disconnected);
      });

      test('sets error status on failure', () async {
        final repo = _FakeGoogleCalendarRepository()
          ..failureToReturn = const RepositoryFailure('network error');
        final controller = _makeController(repo);

        await controller.loadConnectionStatus();

        expect(controller.syncStatus.value, GoogleSyncStatus.error);
        expect(controller.errorMessage.value, 'network error');
      });
    });

    group('connectGoogle', () {
      test('sets pendingAuthUrl on success', () async {
        final repo = _FakeGoogleCalendarRepository()
          ..urlToReturn = 'https://accounts.google.com/auth?client_id=test';
        final controller = _makeController(repo);

        await controller.connectGoogle();

        expect(controller.pendingAuthUrl.value, isNotNull);
        expect(controller.pendingAuthUrl.value, contains('accounts.google.com'));
      });

      test('sets errorMessage on failure', () async {
        final repo = _FakeGoogleCalendarRepository()
          ..failureToReturn = const RepositoryFailure('auth error');
        final controller = _makeController(repo);

        await controller.connectGoogle();

        expect(controller.errorMessage.value, 'auth error');
        expect(controller.pendingAuthUrl.value, isNull);
      });
    });

    group('submitAuthCode', () {
      test('ignores empty code', () async {
        final repo = _FakeGoogleCalendarRepository();
        final controller = _makeController(repo);

        await controller.submitAuthCode('');

        expect(controller.connection.value, isNull);
      });

      test('calls exchangeCode and reloads status on success', () async {
        final repo = _FakeGoogleCalendarRepository()
          ..connectionToReturn = _connection();
        final controller = _makeController(repo);

        await controller.submitAuthCode('valid-code');

        expect(controller.connection.value, isNotNull);
        expect(controller.syncStatus.value, GoogleSyncStatus.connected);
      });
    });

    group('disconnectGoogle', () {
      test('calls disconnect and resets connection', () async {
        final repo = _FakeGoogleCalendarRepository();
        final controller = _makeController(repo);

        await controller.disconnectGoogle();

        expect(repo.disconnectCalled, isTrue);
        expect(controller.syncStatus.value, GoogleSyncStatus.disconnected);
      });
    });

    group('manualSync', () {
      test('calls triggerSync and updates status', () async {
        final repo = _FakeGoogleCalendarRepository()
          ..connectionToReturn = _connection();
        final controller = _makeController(repo);

        await controller.manualSync();

        expect(repo.triggerCalled, isTrue);
        expect(controller.isSyncing.value, isFalse);
      });
    });
  });
}
