import 'package:get/get.dart';

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
  );

  final UseCase<ClientHistory, FetchClientHistoryParams> _fetchClientHistory;
  final UseCase<void, DeleteClientParams> _deleteClient;
  final NavigationService _nav;

  final client = Rxn<ClientViewModel>();
  final history = Rxn<ClientHistory>();
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

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
