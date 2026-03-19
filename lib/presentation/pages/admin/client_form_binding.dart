import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../domain/entities/client.dart';
import '../../../usecases/client/params.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/client_form_controller.dart';
import '../../controllers/clients_controller.dart';
import '../../models/client_view_model.dart';
import '../../services/navigation_service.dart';

class ClientFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('ClientFormBinding: registering dependencies');
    final vm = Get.arguments as ClientViewModel?;
    final client = vm != null
        ? Get.find<ClientsController>().entityById(vm.id)
        : null;
    Get.lazyPut<ClientFormController>(
      () => ClientFormController(
        Get.find<UseCase<Client, SaveClientParams>>(
          tag: vm != null ? 'updateClient' : 'createClient',
        ),
        navigationService: Get.find<NavigationService>(),
        existingClient: client,
      ),
    );
  }
}
