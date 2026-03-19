import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../domain/entities/client.dart';
import '../../../usecases/client/params.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/client_form_controller.dart';
import '../../services/navigation_service.dart';

class ClientFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('ClientFormBinding: registering dependencies');
    final client = Get.arguments as Client?;
    Get.lazyPut<ClientFormController>(
      () => ClientFormController(
        Get.find<UseCase<Client, SaveClientParams>>(
          tag: client != null ? 'updateClient' : 'createClient',
        ),
        navigationService: Get.find<NavigationService>(),
        existingClient: client,
      ),
    );
  }
}
