import 'package:declia/core/enums/acquisition_source.dart';
import 'package:declia/core/enums/client_sort_field.dart';
import 'package:declia/core/enums/sort_direction.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/clock.dart';
import 'package:declia/core/utils/paged_result.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/domain/entities/client_list_query.dart';
import 'package:declia/domain/entities/client_summary_stats.dart';
import 'package:declia/presentation/controllers/clients_controller.dart';
import 'package:declia/usecases/client/params.dart';
import 'package:declia/usecases/client_history/params.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fakes.dart';

final Clock _clock = FakeClock(DateTime(2026, 3, 18));

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

final class _FakeFetchSummaryStats
    extends UseCase<Map<String, ClientSummaryStats>, FetchSummaryStatsParams> {
  Map<String, ClientSummaryStats>? statsToReturn;
  Failure? failureToReturn;

  @override
  Future<Result<Map<String, ClientSummaryStats>, Failure>> call(
    FetchSummaryStatsParams params,
  ) async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(statsToReturn ?? {});
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

final class _FakeFetchDistinctTags extends UseCase<List<String>, NoParams> {
  List<String> tagsToReturn = [];
  Failure? failureToReturn;

  @override
  Future<Result<List<String>, Failure>> call(NoParams params) async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(tagsToReturn);
  }
}

ClientsController _makeController({
  _FakeFetchClientList? fetch,
  _FakeDeleteClient? delete,
  _FakeFetchSummaryStats? stats,
  _FakeFetchDistinctTags? tags,
  Clock? clock,
}) {
  return ClientsController(
    fetch ?? _FakeFetchClientList(),
    delete ?? _FakeDeleteClient(),
    FakeClientNavigationService(),
    stats ?? _FakeFetchSummaryStats(),
    tags ?? _FakeFetchDistinctTags(),
    clock ?? _clock,
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

    group('availableTags', () {
      test('populated on init from fetchDistinctTags', () async {
        final tags = _FakeFetchDistinctTags()
          ..tagsToReturn = ['portrait', 'wedding'];
        final controller = _makeController(tags: tags);
        controller.onInit();

        await Future<void>.delayed(Duration.zero);

        expect(controller.availableTags, ['portrait', 'wedding']);
      });

      test('stays empty when fetchDistinctTags fails (non-fatal)', () async {
        final tags = _FakeFetchDistinctTags()
          ..failureToReturn = const RepositoryFailure('error');
        final controller = _makeController(tags: tags);
        controller.onInit();

        await Future<void>.delayed(Duration.zero);

        expect(controller.availableTags, isEmpty);
        expect(controller.errorMessage.value, isNull);
      });
    });

    group('search debounce', () {
      test('updates query and triggers reload after delay', () async {
        final fetch = _FakeFetchClientList()
          ..result = const PagedResult(items: [], totalCount: 0);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        final countBefore = fetch.callCount;
        controller.searchQuery.value = 'Alice';
        await Future<void>.delayed(const Duration(milliseconds: 350));

        expect(fetch.callCount, greaterThan(countBefore));
        expect(fetch.lastQuery?.search, 'Alice');
        expect(fetch.lastQuery?.page, 0);
      });

      test('resets page to 0 when searching', () async {
        final fetch = _FakeFetchClientList()
          ..result = const PagedResult(items: [], totalCount: 100);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        controller.goToPage(1);
        await Future<void>.delayed(Duration.zero);
        expect(controller.query.value.page, 1);

        controller.searchQuery.value = 'Bob';
        await Future<void>.delayed(const Duration(milliseconds: 350));

        expect(controller.query.value.page, 0);
      });
    });

    group('selection', () {
      test('toggleSelect adds and removes ID', () async {
        final fetch = _FakeFetchClientList()
          ..result = PagedResult(items: _fixtureClients, totalCount: 2);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        controller.toggleSelect('1');
        expect(controller.selectedIds, contains('1'));

        controller.toggleSelect('1');
        expect(controller.selectedIds, isNot(contains('1')));
      });

      test('isAllSelected is true when all items selected', () async {
        final fetch = _FakeFetchClientList()
          ..result = PagedResult(items: _fixtureClients, totalCount: 2);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        controller.toggleSelect('1');
        controller.toggleSelect('2');
        expect(controller.isAllSelected, isTrue);
      });

      test('isAllSelected is false when partial selection', () async {
        final fetch = _FakeFetchClientList()
          ..result = PagedResult(items: _fixtureClients, totalCount: 2);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        controller.toggleSelect('1');
        expect(controller.isAllSelected, isFalse);
      });

      test('toggleSelectAll selects all visible then clears', () async {
        final fetch = _FakeFetchClientList()
          ..result = PagedResult(items: _fixtureClients, totalCount: 2);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        controller.toggleSelectAll();
        expect(controller.selectedIds.length, 2);
        expect(controller.isAllSelected, isTrue);

        controller.toggleSelectAll();
        expect(controller.selectedIds, isEmpty);
      });

      test('loadClients clears selection', () async {
        final fetch = _FakeFetchClientList()
          ..result = PagedResult(items: _fixtureClients, totalCount: 2);
        final controller = _makeController(fetch: fetch);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        controller.toggleSelect('1');
        expect(controller.selectedIds, isNotEmpty);

        await controller.loadClients();
        expect(controller.selectedIds, isEmpty);
      });

      test('removeClient deselects deleted ID', () async {
        final fetch = _FakeFetchClientList()
          ..result = PagedResult(items: _fixtureClients, totalCount: 2);
        final delete = _FakeDeleteClient();
        final controller = _makeController(fetch: fetch, delete: delete);
        controller.onInit();
        await Future<void>.delayed(Duration.zero);

        controller.toggleSelect('1');
        expect(controller.selectedIds, contains('1'));

        await controller.removeClient('1');
        expect(controller.selectedIds, isNot(contains('1')));
      });
    });

    group('stats integration', () {
      test('merges summary stats into client view models', () async {
        final fetch = _FakeFetchClientList()
          ..result = PagedResult(items: _fixtureClients, totalCount: 2);
        final stats = _FakeFetchSummaryStats()
          ..statsToReturn = {
            '1': const ClientSummaryStats(
              clientId: '1',
              sessionCount: 5,
              totalSpent: 300.0,
            ),
          };
        final controller = _makeController(fetch: fetch, stats: stats);
        controller.onInit();

        // Wait for both loads (clients + stats)
        await Future<void>.delayed(const Duration(milliseconds: 10));

        final alice = controller.clients.firstWhere((c) => c.id == '1');
        expect(alice.sessionCount, 5);
        expect(alice.totalSpent, 300.0);
      });

      test('stats failure leaves columns as null (non-fatal)', () async {
        final fetch = _FakeFetchClientList()
          ..result = PagedResult(items: _fixtureClients, totalCount: 2);
        final stats = _FakeFetchSummaryStats()
          ..failureToReturn = const RepositoryFailure('stats error');
        final controller = _makeController(fetch: fetch, stats: stats);
        controller.onInit();

        await Future<void>.delayed(const Duration(milliseconds: 10));

        expect(controller.clients.length, 2);
        expect(controller.errorMessage.value, isNull);
        expect(controller.clients.first.sessionCount, isNull);
      });
    });
  });
}
