import 'dart:async';

import 'package:get/get.dart';

import '../../core/enums/acquisition_source.dart';
import '../../core/enums/client_sort_field.dart';
import '../../core/enums/sort_direction.dart';
import '../../core/utils/paged_result.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/client_list_query.dart';
import '../../domain/entities/client_summary_stats.dart';
import '../../usecases/client/params.dart';
import '../../usecases/client_history/params.dart';
import '../../usecases/usecase.dart';
import '../models/client_view_model.dart';
import '../services/navigation_service.dart';

final class ClientsController extends GetxController {
  ClientsController(
    this._fetchClientList,
    this._deleteClient,
    this._nav,
    this._fetchSummaryStats,
    this._fetchDistinctTags,
  );

  final UseCase<PagedResult<Client>, FetchClientsParams> _fetchClientList;
  final UseCase<void, DeleteClientParams> _deleteClient;
  final NavigationService _nav;
  final UseCase<Map<String, ClientSummaryStats>, FetchSummaryStatsParams>
  _fetchSummaryStats;
  final UseCase<List<String>, NoParams> _fetchDistinctTags;

  final clients = <ClientViewModel>[].obs;
  final _entityMap = <String, Client>{};
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final searchQuery = ''.obs;
  final query = const ClientListQuery().obs;
  final totalCount = 0.obs;
  final availableTags = <String>[].obs;

  Timer? _searchTimer;

  Client? entityById(String id) => _entityMap[id];

  int get totalPages => totalCount.value == 0
      ? 1
      : (totalCount.value / query.value.pageSize).ceil();
  bool get hasNextPage => query.value.page < totalPages - 1;
  bool get hasPreviousPage => query.value.page > 0;
  bool get hasActiveFilters =>
      query.value.tags.isNotEmpty || query.value.acquisitionSource != null;

  @override
  void onInit() {
    super.onInit();
    loadClients();
    _loadTags();
    ever(searchQuery, (q) {
      _searchTimer?.cancel();
      _searchTimer = Timer(const Duration(milliseconds: 300), () {
        query.value = query.value.copyWith(search: q.trim(), page: 0);
        loadClients();
      });
    });
  }

  @override
  void onClose() {
    _searchTimer?.cancel();
    super.onClose();
  }

  Future<void> _loadTags() async {
    final result = await _fetchDistinctTags(const NoParams());
    result.fold(ok: (tags) => availableTags.assignAll(tags), err: (_) {});
  }

  Future<void> loadClients() async {
    isLoading.value = true;
    errorMessage.value = null;
    final result = await _fetchClientList((query: query.value));
    result.fold(
      ok: (paged) {
        _entityMap
          ..clear()
          ..addEntries(paged.items.map((c) => MapEntry(c.id, c)));
        clients.assignAll(paged.items.map(ClientViewModel.fromEntity));
        totalCount.value = paged.totalCount;
      },
      err: (failure) => errorMessage.value = failure.message,
    );
    isLoading.value = false;

    if (result.isOk) {
      await _loadStats();
    }
  }

  Future<void> _loadStats() async {
    final ids = _entityMap.keys.toList();
    if (ids.isEmpty) return;
    final statsResult = await _fetchSummaryStats((clientIds: ids));
    statsResult.fold(
      ok: (statsMap) {
        clients.assignAll(
          _entityMap.values.map(
            (c) => ClientViewModel.fromEntity(c, stats: statsMap[c.id]),
          ),
        );
      },
      // Stats failure is non-fatal — columns stay "—"
      err: (_) {},
    );
  }

  // Filter methods
  void setTagFilter(List<String> tags) {
    query.value = query.value.copyWith(tags: tags, page: 0);
    loadClients();
  }

  void addTag(String tag) {
    if (!query.value.tags.contains(tag)) {
      setTagFilter([...query.value.tags, tag]);
    }
  }

  void removeTag(String tag) {
    setTagFilter(query.value.tags.where((t) => t != tag).toList());
  }

  void setAcquisitionSourceFilter(AcquisitionSource? source) {
    query.value = query.value.copyWith(acquisitionSource: source, page: 0);
    loadClients();
  }

  void clearFilters() {
    query.value = query.value.copyWith(
      tags: [],
      acquisitionSource: null,
      page: 0,
    );
    loadClients();
  }

  // Sort methods
  void setSort(ClientSortField field, SortDirection direction) {
    query.value = query.value.copyWith(
      sortField: field,
      sortDirection: direction,
      page: 0,
    );
    loadClients();
  }

  void toggleSort(ClientSortField field) {
    if (query.value.sortField == field) {
      final newDirection = query.value.sortDirection == SortDirection.ascending
          ? SortDirection.descending
          : SortDirection.ascending;
      setSort(field, newDirection);
    } else {
      setSort(field, SortDirection.ascending);
    }
  }

  // Pagination
  void goToPage(int page) {
    if (page < 0 || page >= totalPages) return;
    query.value = query.value.copyWith(page: page);
    loadClients();
  }

  void nextPage() => goToPage(query.value.page + 1);
  void previousPage() => goToPage(query.value.page - 1);

  void viewClient(ClientViewModel vm) =>
      _nav.toClientDetail(vm.id, arguments: vm);
  void editClient(ClientViewModel vm) =>
      _nav.toClientEdit(vm.id, arguments: vm);
  void createNewClient() => _nav.toClientNew();

  Future<bool> removeClient(String id) async {
    final result = await _deleteClient((id: id));
    return result.fold(
      ok: (_) {
        _entityMap.remove(id);
        clients.removeWhere((c) => c.id == id);
        if (totalCount.value > 0) totalCount.value--;
        return true;
      },
      err: (failure) {
        errorMessage.value = failure.message;
        return false;
      },
    );
  }
}
