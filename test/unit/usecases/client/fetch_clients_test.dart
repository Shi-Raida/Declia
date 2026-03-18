import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/domain/repositories/client_repository.dart';
import 'package:declia/usecases/client/fetch_clients.dart';
import 'package:declia/usecases/usecase.dart';
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
  Client(
    id: '2',
    tenantId: 'tid',
    firstName: 'Bob',
    lastName: 'Martin',
    createdAt: _now,
    updatedAt: _now,
  ),
];

final class _FakeClientRepository implements ClientRepository {
  List<Client> clientsToReturn = [];
  Failure? failureToReturn;

  @override
  Future<Result<List<Client>, Failure>> fetchAll() async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(clientsToReturn);
  }

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
}

void main() {
  late _FakeClientRepository repo;
  late FetchClients fetchClients;

  setUp(() {
    repo = _FakeClientRepository();
    fetchClients = FetchClients(repo);
  });

  group('FetchClients', () {
    test('returns Ok with list of clients', () async {
      repo.clientsToReturn = _fixtureClients;

      final result = await fetchClients(const NoParams());

      expect(result, isA<Ok<List<Client>, Failure>>());
      final clients = (result as Ok<List<Client>, Failure>).value;
      expect(clients.length, 2);
      expect(clients.first.firstName, 'Alice');
    });

    test('returns Ok with empty list when no clients', () async {
      repo.clientsToReturn = [];

      final result = await fetchClients(const NoParams());

      expect(result, isA<Ok<List<Client>, Failure>>());
      expect((result as Ok<List<Client>, Failure>).value, isEmpty);
    });

    test('returns Err when repository fails', () async {
      repo.failureToReturn = const RepositoryFailure('DB error');

      final result = await fetchClients(const NoParams());

      expect(result, isA<Err<List<Client>, Failure>>());
      expect(
        (result as Err<List<Client>, Failure>).error,
        isA<RepositoryFailure>(),
      );
    });
  });
}
