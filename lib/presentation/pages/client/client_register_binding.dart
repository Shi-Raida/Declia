import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../usecases/auth/params.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/client_register_controller.dart';
import '../../services/navigation_service.dart';

class ClientRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace(
      'ClientRegisterBinding: registering dependencies',
    );
    final tenantSlug = Get.parameters['tenant'] ?? '';
    Get.lazyPut<ClientRegisterController>(
      () => ClientRegisterController(
        Get.find<UseCase<void, SignUpParams>>(),
        Get.find<AppLogger>(),
        tenantSlug,
        Get.find<NavigationService>(),
      ),
      fenix: true,
    );
  }
}
