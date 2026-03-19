import 'package:get/get.dart';

import '../../../core/logger/app_logger.dart';
import '../../../core/utils/paged_result.dart';
import '../../../domain/entities/client.dart';
import '../../../domain/entities/client_summary_stats.dart';
import '../../../usecases/client/params.dart';
import '../../../usecases/client_history/params.dart';
import '../../../usecases/usecase.dart';
import '../../controllers/clients_controller.dart';
import '../../services/navigation_service.dart';

class ClientsBinding extends Bindings {
  @override
  void dependencies() {
    Get.find<AppLogger>().trace('ClientsBinding: registering dependencies');
    Get.lazyPut<ClientsController>(
      () => ClientsController(
        Get.find<UseCase<PagedResult<Client>, FetchClientsParams>>(),
        Get.find<UseCase<void, DeleteClientParams>>(),
        Get.find<NavigationService>(),
        Get.find<
          UseCase<Map<String, ClientSummaryStats>, FetchSummaryStatsParams>
        >(),
        Get.find<UseCase<List<String>, NoParams>>(tag: 'fetchDistinctTags'),
      ),
    );
  }
}
