import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/clock.dart';
import '../../core/utils/paged_result.dart';
import '../../core/enums/client_status.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/client_summary_stats.dart';
import '../../usecases/client/params.dart';
import '../../usecases/client_history/params.dart';
import '../../usecases/usecase.dart';
import '../models/client_view_model.dart';
import '../services/client_navigation_service.dart';
import 'client_list_query_mixin.dart';
import 'client_pagination_mixin.dart';
import 'client_selection_mixin.dart';

final class ClientsController extends GetxController
    with ClientListQueryMixin, ClientPaginationMixin, ClientSelectionMixin {
  ClientsController(
    this._fetchClientList,
    this._deleteClient,
    this._nav,
    this._fetchSummaryStats,
    this._fetchDistinctTags,
    this._clock,
  );

  final UseCase<PagedResult<Client>, FetchClientsParams> _fetchClientList;
  final UseCase<void, DeleteClientParams> _deleteClient;
  final ClientNavigationService _nav;
  final UseCase<Map<String, ClientSummaryStats>, FetchSummaryStatsParams>
  _fetchSummaryStats;
  final UseCase<List<String>, NoParams> _fetchDistinctTags;
  final Clock _clock;

  final clients = <ClientViewModel>[].obs;
  final _entityMap = <String, Client>{};
  final _allViewModels = <ClientViewModel>[];
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final availableTags = <String>[].obs;

  @override
  List<String> get allItemIds => _allViewModels.map((vm) => vm.id).toList();

  @override
  List<String> get visibleItemIds => clients.map((vm) => vm.id).toList();

  Client? entityById(String id) => _entityMap[id];

  int get activeCount => _allViewModels
      .where((vm) => vm.clientStatus(_clock.now()) == ClientStatus.actif)
      .length;

  int get vipCount => _allViewModels
      .where((vm) => vm.clientStatus(_clock.now()) == ClientStatus.vip)
      .length;

  String get avgRevenueDisplay {
    final withSpent =
        _allViewModels.where((vm) => vm.totalSpent != null).toList();
    if (withSpent.isEmpty) return '—';
    final avg =
        withSpent.fold<double>(0, (sum, vm) => sum + vm.totalSpent!) /
        withSpent.length;
    return '${avg.toStringAsFixed(0)} €';
  }

  @override
  void onQueryChanged() => loadClients();

  @override
  void onLocalFilterChanged() => _applyLocalFilters();

  @override
  void onInit() {
    super.onInit();
    loadClients();
    _loadTags();
  }

  Future<void> _loadTags() async {
    final result = await _fetchDistinctTags(const NoParams());
    result.fold(ok: (tags) => availableTags.assignAll(tags), err: (_) {});
  }

  Future<void> loadClients() async {
    isLoading.value = true;
    errorMessage.value = null;
    clearSelection();
    final result = await _fetchClientList((query: query.value));
    result.fold(
      ok: (paged) {
        _entityMap
          ..clear()
          ..addEntries(paged.items.map((c) => MapEntry(c.id, c)));
        _allViewModels
          ..clear()
          ..addAll(paged.items.map(ClientViewModel.fromEntity));
        totalCount.value = paged.totalCount;
        _applyLocalFilters();
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
        _allViewModels
          ..clear()
          ..addAll(
            _entityMap.values.map(
              (c) => ClientViewModel.fromEntity(c, stats: statsMap[c.id]),
            ),
          );
        _applyLocalFilters();
      },
      // Stats failure is non-fatal — columns stay "—"
      err: (_) {},
    );
  }

  void _applyLocalFilters() {
    final q = query.value;
    var filtered = _allViewModels.toList();
    if (q.statusFilter != null) {
      filtered = filtered
          .where((vm) => vm.clientStatus(_clock.now()) == q.statusFilter)
          .toList();
    }
    if (q.sessionTypeFilter != null) {
      filtered = filtered
          .where((vm) => vm.sessionTypes.contains(q.sessionTypeFilter))
          .toList();
    }
    clients.assignAll(filtered);
  }

  void viewClient(ClientViewModel vm) =>
      _nav.toClientDetail(vm.id, arguments: vm);
  void editClient(ClientViewModel vm) =>
      _nav.toClientEdit(vm.id, arguments: vm);
  void createNewClient() => _nav.toClientNew();
  Future<void> messageClient(ClientViewModel vm) async {
    if (vm.email == null) return;
    final uri = Uri(scheme: 'mailto', path: vm.email);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<bool> removeClient(String id) async {
    final result = await _deleteClient((id: id));
    return result.fold(
      ok: (_) {
        _entityMap.remove(id);
        _allViewModels.removeWhere((c) => c.id == id);
        deselectId(id);
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
