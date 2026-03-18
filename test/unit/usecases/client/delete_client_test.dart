import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/domain/repositories/client_repository.dart';
import 'package:declia/usecases/client/delete_client.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeClientRepository implements ClientRepository {
  String? deletedId;
  Failure? failureToReturn;

  @override
  Future<Result<void, Failure>> delete(String id) async {
    if (failureToReturn != null) return Err(failureToReturn!);
    deletedId = id;
    return const Ok(null);
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
  Future<Result<List<Client>, Failure>> search(String query) =>
      throw UnimplementedError();
}

void main() {
  late _FakeClientRepository repo;
  late DeleteClient deleteClient;

  setUp(() {
    repo = _FakeClientRepository();
    deleteClient = DeleteClient(repo);
  });

  group('DeleteClient', () {
    test('calls repository.delete with the given id', () async {
      const id = 'client-123';

      final result = await deleteClient((id: id));

      expect(result, isA<Ok<void, Failure>>());
      expect(repo.deletedId, id);
    });

    test('propagates repository failure', () async {
      repo.failureToReturn = const ClientNotFoundFailure(
        'Client not found: client-999',
      );

      final result = await deleteClient((id: 'client-999'));

      expect(result, isA<Err<void, Failure>>());
      expect((result as Err).error, isA<ClientNotFoundFailure>());
    });
  });
}
