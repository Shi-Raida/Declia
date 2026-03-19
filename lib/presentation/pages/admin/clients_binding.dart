import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../domain/entities/client.dart';
import '../../../usecases/client/params.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/clients_controller.dart';
import '../../services/navigation_service.dart';

class ClientsBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('ClientsBinding: registering dependencies');
    Get.lazyPut<ClientsController>(
      () => ClientsController(
        Get.find<UseCase<List<Client>, NoParams>>(),
        Get.find<UseCase<List<Client>, SearchClientsParams>>(),
        Get.find<UseCase<void, DeleteClientParams>>(),
        Get.find<NavigationService>(),
      ),
    );
  }
}
