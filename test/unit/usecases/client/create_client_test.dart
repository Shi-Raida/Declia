import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/clock.dart';
import 'package:declia/core/utils/paged_result.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/domain/entities/client_list_query.dart';
import 'package:declia/domain/entities/communication_preferences.dart';
import 'package:declia/domain/repositories/client_repository.dart';
import 'package:declia/usecases/client/create_client.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 18);

final class _FakeClock implements Clock {
  @override
  DateTime now() => _now;
}

final class _FakeClientRepository implements ClientRepository {
  Client? created;

  @override
  Future<Result<Client, Failure>> create(Client client) async {
    created = client;
    return Ok(client.copyWith(id: 'generated-id', tenantId: 'tid'));
  }

  @override
  Future<Result<List<Client>, Failure>> fetchAll() =>
      throw UnimplementedError();
  @override
  Future<Result<Client, Failure>> fetchById(String id) =>
      throw UnimplementedError();
  @override
  Future<Result<Client, Failure>> update(Client client) =>
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
  late CreateClient createClient;

  setUp(() {
    repo = _FakeClientRepository();
    createClient = CreateClient(repo, _FakeClock());
  });

  Client makeClient({
    CommunicationPreferences? prefs,
    DateTime? gdprConsentDate,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Client(
    id: '',
    tenantId: '',
    firstName: 'Alice',
    lastName: 'Dupont',
    communicationPrefs: prefs,
    gdprConsentDate: gdprConsentDate,
    createdAt: createdAt ?? DateTime(0),
    updatedAt: updatedAt ?? DateTime(0),
  );

  group('CreateClient', () {
    test(
      'delegates to repository and returns Ok with created client',
      () async {
        final client = makeClient();

        final result = await createClient((client: client));

        expect(result, isA<Ok<Client, Failure>>());
        expect(repo.created, isNotNull);
      },
    );

    test('stamps createdAt and updatedAt from clock', () async {
      final client = makeClient(createdAt: DateTime(0), updatedAt: DateTime(0));

      await createClient((client: client));

      expect(repo.created!.createdAt, equals(_now.toUtc()));
      expect(repo.created!.updatedAt, equals(_now.toUtc()));
    });

    test(
      'sets gdprConsentDate when email pref is enabled and date is null',
      () async {
        final client = makeClient(
          prefs: const CommunicationPreferences(email: true),
        );

        await createClient((client: client));

        expect(repo.created!.gdprConsentDate, equals(_now.toUtc()));
      },
    );

    test('sets gdprConsentDate when sms pref is enabled', () async {
      final client = makeClient(
        prefs: const CommunicationPreferences(sms: true),
      );

      await createClient((client: client));

      expect(repo.created!.gdprConsentDate, equals(_now.toUtc()));
    });

    test('does not overwrite existing gdprConsentDate', () async {
      final existingDate = DateTime(2025, 1, 1);
      final client = makeClient(
        prefs: const CommunicationPreferences(email: true),
        gdprConsentDate: existingDate,
      );

      await createClient((client: client));

      expect(repo.created!.gdprConsentDate, existingDate);
    });

    test('does not set gdprConsentDate when all prefs are false', () async {
      final client = makeClient(prefs: const CommunicationPreferences());

      await createClient((client: client));

      expect(repo.created!.gdprConsentDate, isNull);
    });

    test(
      'does not set gdprConsentDate when communicationPrefs is null',
      () async {
        final client = makeClient();

        await createClient((client: client));

        expect(repo.created!.gdprConsentDate, isNull);
      },
    );
  });
}
