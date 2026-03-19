import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/repositories/repository_guard.dart';
import 'package:declia/core/utils/paged_result.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/domain/entities/client_list_query.dart';
import 'package:declia/infrastructure/datasources/contract/client_data_source.dart';
import 'package:declia/infrastructure/repositories/client_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 18);

const _clientId = '00000000-0000-0000-0002-000000000001';
const _tenantId = '00000000-0000-0000-0000-000000000001';

final _fixtureClient = Client(
  id: _clientId,
  tenantId: _tenantId,
  firstName: 'Alice',
  lastName: 'Dupont',
  email: 'alice@test.com',
  createdAt: _now,
  updatedAt: _now,
);

final class _FakeClientDataSource implements ClientDataSource {
  List<Client> clients = [_fixtureClient];
  bool deleteCalled = false;
  String? deletedId;
  AppException? exceptionToThrow;

  @override
  Future<List<Client>> fetchAll() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return clients;
  }

  @override
  Future<Client> fetchById(String id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return clients.firstWhere((c) => c.id == id);
  }

  @override
  Future<Client> create(Client client) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    final created = client.copyWith(id: 'new-id', tenantId: _tenantId);
    clients.add(created);
    return created;
  }

  @override
  Future<Client> update(Client client) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return client;
  }

  @override
  Future<void> delete(String id) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    deleteCalled = true;
    deletedId = id;
    clients.removeWhere((c) => c.id == id);
  }

  @override
  Future<List<Client>> search(String query) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return clients
        .where(
          (c) =>
              c.firstName.contains(query) ||
              c.lastName.contains(query) ||
              (c.email?.contains(query) ?? false),
        )
        .toList();
  }

  @override
  Future<(List<Client>, int)> fetchList(ClientListQuery query) async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return (clients, clients.length);
  }

  List<String> tagsToReturn = ['portrait', 'wedding'];

  @override
  Future<List<String>> fetchDistinctTags() async {
    if (exceptionToThrow != null) throw exceptionToThrow!;
    return tagsToReturn;
  }
}

final class _PassthroughGuard implements RepositoryGuard {
  @override
  Future<Result<T, Failure>> call<T>(
    Future<T> Function() action, {
    required String method,
  }) async {
    try {
      return Ok(await action());
    } on AppException catch (e) {
      return Err(Failure.fromException(e));
    }
  }
}

ClientRepositoryImpl _makeRepo(_FakeClientDataSource ds) =>
    ClientRepositoryImpl(dataSource: ds, guard: _PassthroughGuard());

void main() {
  group('ClientRepositoryImpl', () {
    test('fetchAll returns Ok with client list', () async {
      final ds = _FakeClientDataSource();
      final repo = _makeRepo(ds);

      final result = await repo.fetchAll();

      expect(result, isA<Ok<List<Client>, Failure>>());
      expect((result as Ok<List<Client>, Failure>).value.length, 1);
    });

    test('fetchById returns Ok with the matching client', () async {
      final ds = _FakeClientDataSource();
      final repo = _makeRepo(ds);

      final result = await repo.fetchById(_clientId);

      expect(result, isA<Ok<Client, Failure>>());
      expect((result as Ok<Client, Failure>).value.id, _clientId);
    });

    test('create returns Ok with created client', () async {
      final ds = _FakeClientDataSource();
      final repo = _makeRepo(ds);

      final toCreate = _fixtureClient.copyWith(id: '', tenantId: '');
      final result = await repo.create(toCreate);

      expect(result, isA<Ok<Client, Failure>>());
      expect((result as Ok<Client, Failure>).value.tenantId, _tenantId);
    });

    test('update returns Ok with updated client', () async {
      final ds = _FakeClientDataSource();
      final repo = _makeRepo(ds);

      final updated = _fixtureClient.copyWith(firstName: 'Alicia');
      final result = await repo.update(updated);

      expect(result, isA<Ok<Client, Failure>>());
      expect((result as Ok<Client, Failure>).value.firstName, 'Alicia');
    });

    test('delete calls datasource and returns Ok', () async {
      final ds = _FakeClientDataSource();
      final repo = _makeRepo(ds);

      final result = await repo.delete(_clientId);

      expect(result, isA<Ok<void, Failure>>());
      expect(ds.deleteCalled, isTrue);
      expect(ds.deletedId, _clientId);
    });

    test('search returns Ok with matching clients', () async {
      final ds = _FakeClientDataSource();
      final repo = _makeRepo(ds);

      final result = await repo.search('Alice');

      expect(result, isA<Ok<List<Client>, Failure>>());
      expect((result as Ok<List<Client>, Failure>).value.length, 1);
    });

    test(
      'guard converts ClientNotFoundException to ClientNotFoundFailure',
      () async {
        final ds = _FakeClientDataSource()
          ..exceptionToThrow = const ClientNotFoundException('x');
        final repo = _makeRepo(ds);

        final result = await repo.fetchById('x');

        expect(result, isA<Err<Client, Failure>>());
        expect((result as Err).error, isA<ClientNotFoundFailure>());
      },
    );

    test(
      'guard converts UnauthorisedClientAccessException to failure',
      () async {
        final ds = _FakeClientDataSource()
          ..exceptionToThrow = const UnauthorisedClientAccessException();
        final repo = _makeRepo(ds);

        final result = await repo.fetchAll();

        expect(result, isA<Err<List<Client>, Failure>>());
        expect((result as Err).error, isA<UnauthorisedClientAccessFailure>());
      },
    );

    test('fetchList returns Ok with PagedResult wrapping tuple', () async {
      final ds = _FakeClientDataSource();
      final repo = _makeRepo(ds);

      final result = await repo.fetchList(const ClientListQuery());

      expect(result, isA<Ok<PagedResult<Client>, Failure>>());
      final paged = (result as Ok<PagedResult<Client>, Failure>).value;
      expect(paged.items.length, 1);
      expect(paged.totalCount, 1);
    });

    test('fetchList returns Err when data source throws', () async {
      final ds = _FakeClientDataSource()
        ..exceptionToThrow = const UnauthorisedClientAccessException();
      final repo = _makeRepo(ds);

      final result = await repo.fetchList(const ClientListQuery());

      expect(result, isA<Err<PagedResult<Client>, Failure>>());
      expect((result as Err).error, isA<UnauthorisedClientAccessFailure>());
    });

    test('fetchDistinctTags returns Ok with tag list', () async {
      final ds = _FakeClientDataSource()..tagsToReturn = ['portrait', 'wedding'];
      final repo = _makeRepo(ds);

      final result = await repo.fetchDistinctTags();

      expect(result, isA<Ok<List<String>, Failure>>());
      expect((result as Ok<List<String>, Failure>).value, ['portrait', 'wedding']);
    });

    test('fetchDistinctTags returns Err when data source throws', () async {
      final ds = _FakeClientDataSource()
        ..exceptionToThrow = const UnauthorisedClientAccessException();
      final repo = _makeRepo(ds);

      final result = await repo.fetchDistinctTags();

      expect(result, isA<Err<List<String>, Failure>>());
      expect((result as Err).error, isA<UnauthorisedClientAccessFailure>());
    });
  });
}
