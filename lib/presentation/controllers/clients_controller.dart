import 'package:get/get.dart';

import '../../domain/entities/client.dart';
import '../../usecases/client/params.dart';
import '../../usecases/usecase.dart';

final class ClientsController extends GetxController {
  ClientsController(
    this._fetchClients,
    this._searchClients,
    this._deleteClient,
  );

  final UseCase<List<Client>, NoParams> _fetchClients;
  final UseCase<List<Client>, SearchClientsParams> _searchClients;
  final UseCase<void, DeleteClientParams> _deleteClient;

  final clients = <Client>[].obs;
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();
  final searchQuery = ''.obs;

  Worker? _debounceWorker;

  @override
  void onInit() {
    super.onInit();
    loadClients();
    _debounceWorker = debounce(
      searchQuery,
      (_) => _performSearch(),
      time: const Duration(milliseconds: 300),
    );
  }

  @override
  void onClose() {
    _debounceWorker?.dispose();
    super.onClose();
  }

  Future<void> loadClients() async {
    isLoading.value = true;
    errorMessage.value = null;
    final result = await _fetchClients(const NoParams());
    result.fold(
      ok: (value) => clients.assignAll(value),
      err: (failure) => errorMessage.value = failure.message,
    );
    isLoading.value = false;
  }

  Future<void> _performSearch() async {
    final query = searchQuery.value.trim();
    if (query.isEmpty) {
      await loadClients();
      return;
    }
    isLoading.value = true;
    errorMessage.value = null;
    final result = await _searchClients((query: query));
    result.fold(
      ok: (value) => clients.assignAll(value),
      err: (failure) => errorMessage.value = failure.message,
    );
    isLoading.value = false;
  }

  Future<bool> removeClient(String id) async {
    final result = await _deleteClient((id: id));
    return result.fold(
      ok: (_) {
        clients.removeWhere((c) => c.id == id);
        return true;
      },
      err: (failure) {
        errorMessage.value = failure.message;
        return false;
      },
    );
  }
}
