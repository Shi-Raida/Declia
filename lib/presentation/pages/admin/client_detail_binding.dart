import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../domain/entities/client.dart';
import '../../../domain/entities/client_history.dart';
import '../../../usecases/client/params.dart';
import '../../../usecases/client_history/params.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/client_detail_controller.dart';
import '../../services/navigation_service.dart';

class ClientDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace(
      'ClientDetailBinding: registering dependencies',
    );
    Get.put<ClientDetailController>(
      ClientDetailController(
        Get.find<UseCase<ClientHistory, FetchClientHistoryParams>>(),
        Get.find<UseCase<void, DeleteClientParams>>(),
        Get.find<NavigationService>(),
        Get.find<UseCase<Client, GetClientParams>>(),
      ),
    );
  }
}
