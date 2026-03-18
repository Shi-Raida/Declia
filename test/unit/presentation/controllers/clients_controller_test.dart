import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/presentation/controllers/clients_controller.dart';
import 'package:declia/usecases/client/params.dart';
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

final class _FakeFetchClients extends UseCase<List<Client>, NoParams> {
  List<Client> toReturn = [];
  Failure? failureToReturn;

  @override
  Future<Result<List<Client>, Failure>> call(NoParams params) async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(toReturn);
  }
}

final class _FakeSearchClients
    extends UseCase<List<Client>, SearchClientsParams> {
  List<Client> toReturn = [];
  String? lastQuery;

  @override
  Future<Result<List<Client>, Failure>> call(
    SearchClientsParams params,
  ) async {
    lastQuery = params.query;
    return Ok(toReturn);
  }
}

final class _FakeDeleteClient extends UseCase<void, DeleteClientParams> {
  String? deletedId;
  Failure? failureToReturn;

  @override
  Future<Result<void, Failure>> call(DeleteClientParams params) async {
    if (failureToReturn != null) return Err(failureToReturn!);
    deletedId = params.id;
    return const Ok(null);
  }
}

ClientsController _makeController({
  _FakeFetchClients? fetch,
  _FakeSearchClients? search,
  _FakeDeleteClient? delete,
}) {
  return ClientsController(
    fetch ?? _FakeFetchClients(),
    search ?? _FakeSearchClients(),
    delete ?? _FakeDeleteClient(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ClientsController', () {
    test('loadClients populates clients on success', () async {
      final fetch = _FakeFetchClients()..toReturn = _fixtureClients;
      final controller = _makeController(fetch: fetch);
      controller.onInit();

      // Wait for async loadClients to complete
      await Future<void>.delayed(Duration.zero);

      expect(controller.clients.length, 2);
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isNull);
    });

    test('loadClients sets errorMessage on failure', () async {
      final fetch = _FakeFetchClients()
        ..failureToReturn = const RepositoryFailure('DB error');
      final controller = _makeController(fetch: fetch);
      controller.onInit();

      await Future<void>.delayed(Duration.zero);

      expect(controller.clients, isEmpty);
      expect(controller.errorMessage.value, 'DB error');
    });

    test('removeClient removes client from list on success', () async {
      final fetch = _FakeFetchClients()..toReturn = _fixtureClients;
      final delete = _FakeDeleteClient();
      final controller = _makeController(fetch: fetch, delete: delete);
      controller.onInit();

      await Future<void>.delayed(Duration.zero);
      expect(controller.clients.length, 2);

      final success = await controller.removeClient('1');

      expect(success, isTrue);
      expect(controller.clients.length, 1);
      expect(delete.deletedId, '1');
    });

    test('removeClient sets errorMessage on failure', () async {
      final fetch = _FakeFetchClients()..toReturn = _fixtureClients;
      final delete = _FakeDeleteClient()
        ..failureToReturn =
            const UnauthorisedClientAccessFailure('Unauthorized');
      final controller = _makeController(fetch: fetch, delete: delete);
      controller.onInit();

      await Future<void>.delayed(Duration.zero);

      final success = await controller.removeClient('1');

      expect(success, isFalse);
      expect(controller.clients.length, 2); // not removed
      expect(controller.errorMessage.value, isNotNull);
    });
  });
}
