import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/paged_result.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/domain/entities/client_list_query.dart';
import 'package:declia/domain/repositories/client_repository.dart';
import 'package:declia/usecases/client/fetch_client_list.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 18);

final _fixtureClients = [
  Client(
    id: '1',
    tenantId: 'tid',
    firstName: 'Alice',
    lastName: 'Dupont',
    createdAt: _now,
    updatedAt: _now,
  ),
];

final class _FakeClientRepository implements ClientRepository {
  ClientListQuery? lastQuery;
  PagedResult<Client> resultToReturn = PagedResult(
    items: _fixtureClients,
    totalCount: 1,
  );
  Failure? failureToReturn;

  @override
  Future<Result<PagedResult<Client>, Failure>> fetchList(
    ClientListQuery query,
  ) async {
    lastQuery = query;
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(resultToReturn);
  }

  @override
  Future<Result<List<Client>, Failure>> fetchAll() =>
      throw UnimplementedError();
  @override
  Future<Result<Client, Failure>> fetchById(String id) =>
      throw UnimplementedError();
  @override
  Future<Result<Client, Failure>> create(Client client) =>
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
  Future<Result<List<String>, Failure>> fetchDistinctTags() =>
      throw UnimplementedError();
}

void main() {
  late _FakeClientRepository repo;
  late FetchClientList fetchClientList;

  setUp(() {
    repo = _FakeClientRepository();
    fetchClientList = FetchClientList(repo);
  });

  group('FetchClientList', () {
    test('delegates query to repository.fetchList', () async {
      const query = ClientListQuery(search: 'Alice', page: 1);

      await fetchClientList((query: query));

      expect(repo.lastQuery, query);
    });

    test('returns Ok with PagedResult on success', () async {
      final result = await fetchClientList((query: const ClientListQuery()));

      expect(result, isA<Ok<PagedResult<Client>, Failure>>());
      final paged = (result as Ok<PagedResult<Client>, Failure>).value;
      expect(paged.items.length, 1);
      expect(paged.totalCount, 1);
    });

    test('returns Err when repository fails', () async {
      repo.failureToReturn = const RepositoryFailure('DB error');

      final result = await fetchClientList((query: const ClientListQuery()));

      expect(result, isA<Err<PagedResult<Client>, Failure>>());
      expect(
        (result as Err<PagedResult<Client>, Failure>).error,
        isA<RepositoryFailure>(),
      );
    });
  });
}
