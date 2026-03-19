import 'package:declia/core/enums/acquisition_source.dart';
import 'package:declia/core/enums/client_sort_field.dart';
import 'package:declia/core/enums/sort_direction.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/paged_result.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/domain/entities/client_list_query.dart';
import 'package:declia/presentation/controllers/clients_controller.dart';
import 'package:declia/presentation/services/navigation_service.dart';
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

final class _FakeFetchClientList
    extends UseCase<PagedResult<Client>, FetchClientsParams> {
  PagedResult<Client> result = const PagedResult(items: [], totalCount: 0);
  Failure? failureToReturn;
  int callCount = 0;
  ClientListQuery? lastQuery;

  @override
  Future<Result<PagedResult<Client>, Failure>> call(
    FetchClientsParams params,
  ) async {
    callCount++;
    lastQuery = params.query;
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(result);
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

final class _FakeNavigationService implements NavigationService {
  @override
  String get currentRoute => '';
  @override
  void toLogin({String? reason}) {}
  @override
  void toHome(dynamic role) {}
  @override
  void toDashboard() {}
  @override
  void toAdminPage(String route) {}
  @override
  void toClientLogin({String? tenantSlug}) {}
  @override
  void toClientHome() {}
  @override
  void toClientRegister({String? tenantSlug}) {}
  @override
  void toClientForgotPassword() {}
  @override
  void toLegalPrivacy() {}
  @override
  void toClientDetail(String id, {dynamic arguments}) {}
  @override
  void toClientEdit(String id, {dynamic arguments}) {}
  @override
  void toClientNew() {}
  @override
  void goBack() {}
}

ClientsController _makeController({
  _FakeFetchClientList? fetch,
  _FakeDeleteClient? delete,
}) {
  return ClientsController(
    fetch ?? _FakeFetchClientList(),
    delete ?? _FakeDeleteClient(),
    _FakeNavigationService(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ClientsController', () {
    test('loadClients populates clients and totalCount on success', () async {
      final fetch = _FakeFetchClientList()
        ..result = PagedResult(items: _fixtureClients, totalCount: 2);
      final controller = _makeController(fetch: fetch);
      controller.onInit();

      await Future<void>.delayed(Duration.zero);

      expect(controller.clients.length, 2);
      expect(controller.totalCount.value, 2);
      expect(controller.isLoading.value, isFalse);
      expect(controller.errorMessage.value, isNull);
    });

    test('loadClients sets errorMessage on failure', () async {
      final fetch = _FakeFetchClientList()
        ..failureToReturn = const RepositoryFailure('DB error');
      final controller = _makeController(fetch: fetch);
      controller.onInit();

      await Future<void>.delayed(Duration.zero);

      expect(controller.clients, isEmpty);
      expect(controller.totalCount.value, 0);
      expect(controller.errorMessage.value, 'DB error');
    });

    test('addTag updates query and triggers reload', () async {
      final fetch = _FakeFetchClientList()
        ..result = const PagedResult(items: [], totalCount: 0);
      final controller = _makeController(fetch: fetch);
      controller.onInit();
      await Future<void>.delayed(Duration.zero);

      final countBefore = fetch.callCount;
      controller.addTag('wedding');
      await Future<void>.delayed(Duration.zero);

      expect(fetch.callCount, greaterThan(countBefore));
      expect(controller.query.value.tags, contains('wedding'));
      expect(controller.query.value.page, 0);
    });

    test('removeTag updates query and triggers reload', () async {
      final fetch = _FakeFetchClientList()
        ..result = const PagedResult(items: [], totalCount: 0);
      final controller = _makeController(fetch: fetch);
      controller.onInit();
      await Future<void>.delayed(Duration.zero);

      controller.addTag('wedding');
      await Future<void>.delayed(Duration.zero);
      final countBefore = fetch.callCount;

      controller.removeTag('wedding');
      await Future<void>.delayed(Duration.zero);

      expect(fetch.callCount, greaterThan(countBefore));
      expect(controller.query.value.tags, isEmpty);
    });

    test(
      'setAcquisitionSourceFilter updates query and triggers reload',
      () async {
        final fetch = _FakeFetchClientList()
          ..result = const PagedResult(items: [], totalCount: 0);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        final countBefore = fetch.callCount;
        controller.setAcquisitionSourceFilter(AcquisitionSource.referral);
        await Future<void>.delayed(Duration.zero);

        expect(fetch.callCount, greaterThan(countBefore));
        expect(
          controller.query.value.acquisitionSource,
          AcquisitionSource.referral,
        );
      },
    );

    test('clearFilters resets tags and source and triggers reload', () async {
      final fetch = _FakeFetchClientList()
        ..result = const PagedResult(items: [], totalCount: 0);
      final controller = _makeController(fetch: fetch);
      controller.onInit();
      await Future<void>.delayed(Duration.zero);

      controller.addTag('wedding');
      controller.setAcquisitionSourceFilter(AcquisitionSource.event);
      await Future<void>.delayed(Duration.zero);
      final countBefore = fetch.callCount;

      controller.clearFilters();
      await Future<void>.delayed(Duration.zero);

      expect(fetch.callCount, greaterThan(countBefore));
      expect(controller.query.value.tags, isEmpty);
      expect(controller.query.value.acquisitionSource, isNull);
    });

    test(
      'setSort updates sortField and direction and triggers reload',
      () async {
        final fetch = _FakeFetchClientList()
          ..result = const PagedResult(items: [], totalCount: 0);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        final countBefore = fetch.callCount;
        controller.setSort(ClientSortField.createdAt, SortDirection.descending);
        await Future<void>.delayed(Duration.zero);

        expect(fetch.callCount, greaterThan(countBefore));
        expect(controller.query.value.sortField, ClientSortField.createdAt);
        expect(controller.query.value.sortDirection, SortDirection.descending);
      },
    );

    test('toggleSort on same field flips direction', () async {
      final fetch = _FakeFetchClientList()
        ..result = const PagedResult(items: [], totalCount: 0);
      final controller = _makeController(fetch: fetch);
      controller.onInit();
      await Future<void>.delayed(Duration.zero);

      expect(controller.query.value.sortDirection, SortDirection.ascending);
      controller.toggleSort(ClientSortField.name);
      await Future<void>.delayed(Duration.zero);

      expect(controller.query.value.sortDirection, SortDirection.descending);
    });

    test('toggleSort on different field resets to ascending', () async {
      final fetch = _FakeFetchClientList()
        ..result = const PagedResult(items: [], totalCount: 0);
      final controller = _makeController(fetch: fetch);
      controller.onInit();
      await Future<void>.delayed(Duration.zero);

      controller.setSort(ClientSortField.name, SortDirection.descending);
      await Future<void>.delayed(Duration.zero);

      controller.toggleSort(ClientSortField.createdAt);
      await Future<void>.delayed(Duration.zero);

      expect(controller.query.value.sortField, ClientSortField.createdAt);
      expect(controller.query.value.sortDirection, SortDirection.ascending);
    });

    test('goToPage updates page and triggers reload', () async {
      final fetch = _FakeFetchClientList()
        ..result = const PagedResult(items: [], totalCount: 100);
      final controller = _makeController(fetch: fetch);
      controller.onInit();
      await Future<void>.delayed(Duration.zero);

      final countBefore = fetch.callCount;
      controller.goToPage(1);
      await Future<void>.delayed(Duration.zero);

      expect(fetch.callCount, greaterThan(countBefore));
      expect(controller.query.value.page, 1);
    });

    test('goToPage ignores out-of-range page', () async {
      final fetch = _FakeFetchClientList()
        ..result = const PagedResult(items: [], totalCount: 25);
      final controller = _makeController(fetch: fetch);
      controller.onInit();
      await Future<void>.delayed(Duration.zero);

      final countBefore = fetch.callCount;
      controller.goToPage(99);
      await Future<void>.delayed(Duration.zero);

      // Should not load for page 99 when totalPages = 1
      expect(fetch.callCount, countBefore);
    });

    test(
      'removeClient removes client from list and decrements totalCount',
      () async {
        final fetch = _FakeFetchClientList()
          ..result = PagedResult(items: _fixtureClients, totalCount: 2);
        final delete = _FakeDeleteClient();
        final controller = _makeController(fetch: fetch, delete: delete);
        controller.onInit();

        await Future<void>.delayed(Duration.zero);
        expect(controller.clients.length, 2);
        expect(controller.totalCount.value, 2);

        final success = await controller.removeClient('1');

        expect(success, isTrue);
        expect(controller.clients.length, 1);
        expect(controller.totalCount.value, 1);
        expect(delete.deletedId, '1');
      },
    );

    test('removeClient sets errorMessage on failure', () async {
      final fetch = _FakeFetchClientList()
        ..result = PagedResult(items: _fixtureClients, totalCount: 2);
      final delete = _FakeDeleteClient()
        ..failureToReturn = const UnauthorisedClientAccessFailure(
          'Unauthorized',
        );
      final controller = _makeController(fetch: fetch, delete: delete);
      controller.onInit();

      await Future<void>.delayed(Duration.zero);

      final success = await controller.removeClient('1');

      expect(success, isFalse);
      expect(controller.clients.length, 2);
      expect(controller.totalCount.value, 2);
      expect(controller.errorMessage.value, isNotNull);
    });

    group('pagination computed getters', () {
      test('totalPages returns 1 when totalCount is 0', () async {
        final fetch = _FakeFetchClientList()
          ..result = const PagedResult(items: [], totalCount: 0);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        expect(controller.totalPages, 1);
      });

      test('totalPages rounds up correctly', () async {
        final fetch = _FakeFetchClientList()
          ..result = const PagedResult(items: [], totalCount: 26);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        expect(controller.totalPages, 2);
      });

      test('hasPreviousPage is false on first page', () async {
        final fetch = _FakeFetchClientList()
          ..result = const PagedResult(items: [], totalCount: 100);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        expect(controller.hasPreviousPage, isFalse);
      });

      test('hasNextPage is false on last page', () async {
        final fetch = _FakeFetchClientList()
          ..result = const PagedResult(items: [], totalCount: 25);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        expect(controller.hasNextPage, isFalse);
        expect(controller.totalPages, 1);
      });

      test('hasActiveFilters reflects tags and source state', () async {
        final fetch = _FakeFetchClientList()
          ..result = const PagedResult(items: [], totalCount: 0);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        expect(controller.hasActiveFilters, isFalse);
        controller.addTag('portrait');
        await Future<void>.delayed(Duration.zero);
        expect(controller.hasActiveFilters, isTrue);
        controller.clearFilters();
        await Future<void>.delayed(Duration.zero);
        expect(controller.hasActiveFilters, isFalse);
      });
    });
  });
}
