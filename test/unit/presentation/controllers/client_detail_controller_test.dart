import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/domain/entities/client_history.dart';
import 'package:declia/presentation/controllers/client_detail_controller.dart';
import 'package:declia/presentation/models/client_view_model.dart';
import 'package:declia/usecases/client/params.dart';
import 'package:declia/usecases/client_history/params.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

final _now = DateTime(2026, 3, 20);

final _fixtureVm = ClientViewModel(
  id: 'client-1',
  firstName: 'Alice',
  lastName: 'Dupont',
  createdAt: _now,
  tags: const [],
  commEmail: false,
  commSms: false,
  commPhone: false,
);

final _fixtureClient = Client(
  id: 'client-1',
  tenantId: 'tenant-1',
  firstName: 'Alice',
  lastName: 'Dupont',
  createdAt: _now,
  updatedAt: _now,
);

final _fixtureHistory = const ClientHistory(
  clientId: 'client-1',
  sessions: [],
  galleries: [],
  orders: [],
  communicationLogs: [],
);

final class _FakeGetClient extends UseCase<Client, GetClientParams> {
  Client? clientToReturn;
  Failure? failureToReturn;
  int callCount = 0;

  @override
  Future<Result<Client, Failure>> call(GetClientParams params) async {
    callCount++;
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(clientToReturn ?? _fixtureClient);
  }
}

final class _FakeDeleteClient extends UseCase<void, DeleteClientParams> {
  Failure? failureToReturn;
  int callCount = 0;

  @override
  Future<Result<void, Failure>> call(DeleteClientParams params) async {
    callCount++;
    if (failureToReturn != null) return Err(failureToReturn!);
    return const Ok(null);
  }
}

final class _FakeFetchClientHistory
    extends UseCase<ClientHistory, FetchClientHistoryParams> {
  ClientHistory? historyToReturn;
  Failure? failureToReturn;
  int callCount = 0;

  @override
  Future<Result<ClientHistory, Failure>> call(
    FetchClientHistoryParams params,
  ) async {
    callCount++;
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(historyToReturn ?? _fixtureHistory);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ClientDetailController', () {
    test('initialize sets client and loads history on success', () async {
      final fetch = _FakeFetchClientHistory();
      final controller = ClientDetailController(
        fetch,
        _FakeDeleteClient(),
        FakeClientNavigationService(),
        _FakeGetClient(),
      );

      await controller.initialize('client-1', _fixtureVm);

      expect(controller.client.value, isNotNull);
      expect(controller.client.value?.id, 'client-1');
      expect(controller.history.value, isNotNull);
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isNull);
    });

    test('initialize sets errorMessage on failure', () async {
      final fetch = _FakeFetchClientHistory()
        ..failureToReturn = const RepositoryFailure('load error');
      final controller = ClientDetailController(
        fetch,
        _FakeDeleteClient(),
        FakeClientNavigationService(),
        _FakeGetClient(),
      );

      await controller.initialize('client-1', _fixtureVm);

      expect(controller.history.value, isNull);
      expect(controller.errorMessage.value, 'load error');
      expect(controller.isLoading.value, isFalse);
    });

    test('initialize sets initial client immediately (before async)', () async {
      final fetch = _FakeFetchClientHistory();
      final controller = ClientDetailController(
        fetch,
        _FakeDeleteClient(),
        FakeClientNavigationService(),
        _FakeGetClient(),
      );

      // Start but don't await
      final future = controller.initialize('client-1', _fixtureVm);
      // Client should be set synchronously before async completes
      expect(controller.client.value, _fixtureVm);

      await future;
    });

    test('initialize always calls getClient and stores clientEntity', () async {
      final getClient = _FakeGetClient();
      final controller = ClientDetailController(
        _FakeFetchClientHistory(),
        _FakeDeleteClient(),
        FakeClientNavigationService(),
        getClient,
      );

      await controller.initialize('client-1', _fixtureVm);

      expect(getClient.callCount, 1);
      expect(controller.clientEntity, isNotNull);
      expect(controller.clientEntity?.id, 'client-1');
    });

    test('isLoading is false after completion', () async {
      final fetch = _FakeFetchClientHistory();
      final controller = ClientDetailController(
        fetch,
        _FakeDeleteClient(),
        FakeClientNavigationService(),
        _FakeGetClient(),
      );

      await controller.initialize('client-1', _fixtureVm);

      expect(controller.isLoading.value, isFalse);
    });

    test(
      'initialize fetches client from API when no initialVm is provided',
      () async {
        final getClient = _FakeGetClient();
        final controller = ClientDetailController(
          _FakeFetchClientHistory(),
          _FakeDeleteClient(),
          FakeClientNavigationService(),
          getClient,
        );

        await controller.initialize('client-1', null);

        expect(getClient.callCount, 1);
        expect(controller.client.value, isNotNull);
        expect(controller.client.value?.id, 'client-1');
        expect(controller.client.value?.firstName, 'Alice');
        expect(controller.clientEntity, isNotNull);
        expect(controller.clientEntity?.id, 'client-1');
        expect(controller.history.value, isNotNull);
        expect(controller.errorMessage.value, isNull);
      },
    );
  });

  group('ClientDetailController.deleteClient', () {
    test('calls delete use case and navigates back on success', () async {
      final delete = _FakeDeleteClient();
      final nav = FakeClientNavigationService();
      final controller = ClientDetailController(
        _FakeFetchClientHistory(),
        delete,
        nav,
        _FakeGetClient(),
      );
      await controller.initialize('client-1', _fixtureVm);

      await controller.deleteClient();

      expect(delete.callCount, 1);
      expect(controller.errorMessage.value, isNull);
    });

    test('sets errorMessage on delete failure', () async {
      final delete = _FakeDeleteClient()
        ..failureToReturn = const RepositoryFailure('delete error');
      final controller = ClientDetailController(
        _FakeFetchClientHistory(),
        delete,
        FakeClientNavigationService(),
        _FakeGetClient(),
      );
      await controller.initialize('client-1', _fixtureVm);

      await controller.deleteClient();

      expect(controller.errorMessage.value, 'delete error');
    });

    test('does nothing when client is null', () async {
      final delete = _FakeDeleteClient();
      final controller = ClientDetailController(
        _FakeFetchClientHistory(),
        delete,
        FakeClientNavigationService(),
        _FakeGetClient(),
      );
      // Do not initialize — client remains null

      await controller.deleteClient();

      expect(delete.callCount, 0);
    });
  });
}
