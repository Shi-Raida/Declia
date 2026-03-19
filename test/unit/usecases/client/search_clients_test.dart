import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/paged_result.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/domain/entities/client_list_query.dart';
import 'package:declia/domain/repositories/client_repository.dart';
import 'package:declia/usecases/client/search_clients.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 18);

final class _FakeClientRepository implements ClientRepository {
  String? lastQuery;
  List<Client> results = [];

  @override
  Future<Result<List<Client>, Failure>> search(String query) async {
    lastQuery = query;
    return Ok(results);
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
  Future<Result<PagedResult<Client>, Failure>> fetchList(
    ClientListQuery query,
  ) => throw UnimplementedError();
}

void main() {
  late _FakeClientRepository repo;
  late SearchClients searchClients;

  setUp(() {
    repo = _FakeClientRepository();
    searchClients = SearchClients(repo);
  });

  group('SearchClients', () {
    test('passes query to repository', () async {
      await searchClients((query: 'Alice'));

      expect(repo.lastQuery, 'Alice');
    });

    test('returns matching clients', () async {
      repo.results = [
        Client(
          id: '1',
          tenantId: 'tid',
          firstName: 'Alice',
          lastName: 'Dupont',
          createdAt: _now,
          updatedAt: _now,
        ),
      ];

      final result = await searchClients((query: 'Alice'));

      expect(result, isA<Ok<List<Client>, Failure>>());
      final clients = (result as Ok<List<Client>, Failure>).value;
      expect(clients.length, 1);
      expect(clients.first.firstName, 'Alice');
    });

    test('returns empty list when no match', () async {
      repo.results = [];

      final result = await searchClients((query: 'xyz'));

      expect(result, isA<Ok<List<Client>, Failure>>());
      expect((result as Ok<List<Client>, Failure>).value, isEmpty);
    });
  });
}
