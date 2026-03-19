import 'package:get/get.dart';

import '../../domain/entities/client.dart';
import '../../domain/entities/client_history.dart';
import '../../usecases/client/params.dart';
import '../../usecases/client_history/params.dart';
import '../../usecases/usecase.dart';
import '../models/client_view_model.dart';
import '../services/navigation_service.dart';

final class ClientDetailController extends GetxController {
  ClientDetailController(
    this._fetchClientHistory,
    this._deleteClient,
    this._nav,
    this._getClient,
  );

  final UseCase<ClientHistory, FetchClientHistoryParams> _fetchClientHistory;
  final UseCase<void, DeleteClientParams> _deleteClient;
  final NavigationService _nav;
  final UseCase<Client, GetClientParams> _getClient;

  final client = Rxn<ClientViewModel>();
  final history = Rxn<ClientHistory>();
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  Client? _clientEntity;
  Client? get clientEntity => _clientEntity;

  @override
  void onInit() {
    super.onInit();
    final clientId = Get.parameters['id'] ?? '';
    final initialVm = Get.arguments as ClientViewModel?;
    initialize(clientId, initialVm);
  }

  Future<void> initialize(String clientId, ClientViewModel? initialVm) async {
    client.value = initialVm;
    isLoading.value = true;
    errorMessage.value = null;

    if (clientId.isNotEmpty) {
      final clientResult = await _getClient((id: clientId));
      clientResult.fold(
        ok: (c) {
          _clientEntity = c;
          client.value = ClientViewModel.fromEntity(c);
        },
        err: (f) => errorMessage.value = f.message,
      );
      if (errorMessage.value != null) {
        isLoading.value = false;
        return;
      }
    }

    final result = await _fetchClientHistory((clientId: clientId));
    result.fold(
      ok: (h) => history.value = h,
      err: (f) => errorMessage.value = f.message,
    );

    isLoading.value = false;
  }

  void editClient() {
    final vm = client.value;
    if (vm != null) _nav.toClientEdit(vm.id, arguments: vm);
  }

  Future<void> deleteClient() async {
    final vm = client.value;
    if (vm == null) return;
    final result = await _deleteClient((id: vm.id));
    result.fold(
      ok: (_) => _nav.goBack(),
      err: (f) => errorMessage.value = f.message,
    );
  }

  void goBack() => _nav.goBack();
}
