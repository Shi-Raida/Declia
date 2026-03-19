import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/clock.dart';
import 'package:declia/core/utils/paged_result.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/domain/entities/client_list_query.dart';
import 'package:declia/domain/entities/communication_preferences.dart';
import 'package:declia/domain/repositories/client_repository.dart';
import 'package:declia/usecases/client/update_client.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 18);

final class _FakeClock implements Clock {
  @override
  DateTime now() => _now;
}

final class _FakeClientRepository implements ClientRepository {
  Client? updated;

  @override
  Future<Result<Client, Failure>> update(Client client) async {
    updated = client;
    return Ok(client);
  }

  @override
  Future<Result<Client, Failure>> create(Client client) =>
      throw UnimplementedError();
  @override
  Future<Result<List<Client>, Failure>> fetchAll() =>
      throw UnimplementedError();
  @override
  Future<Result<Client, Failure>> fetchById(String id) =>
      throw UnimplementedError();
  @override
  Future<Result<void, Failure>> delete(String id) => throw UnimplementedError();
  @override
  Future<Result<List<Client>, Failure>> search(String query) =>
      throw UnimplementedError();

  @override
  Future<Result<PagedResult<Client>, Failure>> fetchList(
    ClientListQuery query,
  ) => throw UnimplementedError();
}

void main() {
  late _FakeClientRepository repo;
  late UpdateClient updateClient;

  setUp(() {
    repo = _FakeClientRepository();
    updateClient = UpdateClient(repo, _FakeClock());
  });

  final originalCreatedAt = DateTime(2025, 1, 1);

  Client makeClient({
    CommunicationPreferences? prefs,
    DateTime? gdprConsentDate,
  }) => Client(
    id: 'existing-id',
    tenantId: 'tid',
    firstName: 'Alice',
    lastName: 'Dupont',
    communicationPrefs: prefs,
    gdprConsentDate: gdprConsentDate,
    createdAt: originalCreatedAt,
    updatedAt: originalCreatedAt,
  );

  group('UpdateClient', () {
    test(
      'delegates to repository and returns Ok with updated client',
      () async {
        final client = makeClient();

        final result = await updateClient((client: client));

        expect(result, isA<Ok<Client, Failure>>());
        expect(repo.updated, isNotNull);
      },
    );

    test('stamps updatedAt from clock', () async {
      final client = makeClient();

      await updateClient((client: client));

      expect(repo.updated!.updatedAt, equals(_now.toUtc()));
    });

    test('does not modify createdAt', () async {
      final client = makeClient();

      await updateClient((client: client));

      expect(repo.updated!.createdAt, equals(originalCreatedAt));
    });

    test(
      'sets gdprConsentDate when email pref is enabled and date is null',
      () async {
        final client = makeClient(
          prefs: const CommunicationPreferences(email: true),
        );

        await updateClient((client: client));

        expect(repo.updated!.gdprConsentDate, equals(_now.toUtc()));
      },
    );

    test(
      'sets gdprConsentDate when sms pref is enabled and date is null',
      () async {
        final client = makeClient(
          prefs: const CommunicationPreferences(sms: true),
        );

        await updateClient((client: client));

        expect(repo.updated!.gdprConsentDate, equals(_now.toUtc()));
      },
    );

    test('does not overwrite existing gdprConsentDate', () async {
      final existingDate = DateTime(2025, 1, 1);
      final client = makeClient(
        prefs: const CommunicationPreferences(email: true),
        gdprConsentDate: existingDate,
      );

      await updateClient((client: client));

      expect(repo.updated!.gdprConsentDate, existingDate);
    });

    test(
      'preserves existing gdprConsentDate when all prefs are disabled',
      () async {
        final existingDate = DateTime(2025, 1, 1);
        final client = makeClient(
          prefs: const CommunicationPreferences(),
          gdprConsentDate: existingDate,
        );

        await updateClient((client: client));

        expect(repo.updated!.gdprConsentDate, existingDate);
      },
    );

    test('does not set gdprConsentDate when all prefs are false', () async {
      final client = makeClient(prefs: const CommunicationPreferences());

      await updateClient((client: client));

      expect(repo.updated!.gdprConsentDate, isNull);
    });

    test(
      'does not set gdprConsentDate when communicationPrefs is null',
      () async {
        final client = makeClient();

        await updateClient((client: client));

        expect(repo.updated!.gdprConsentDate, isNull);
      },
    );
  });
}
