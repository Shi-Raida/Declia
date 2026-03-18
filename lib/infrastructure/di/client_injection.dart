import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/repositories/repository_guard.dart';
import '../../core/utils/clock.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../../usecases/client/create_client.dart';
import '../../usecases/client/delete_client.dart';
import '../../usecases/client/fetch_clients.dart';
import '../../usecases/client/get_client.dart';
import '../../usecases/client/params.dart';
import '../../usecases/client/search_clients.dart';
import '../../usecases/client/update_client.dart';
import '../../usecases/usecase.dart';
import '../datasources/contract/client_data_source.dart';
import '../datasources/supabase_client_data_source.dart';
import '../repositories/client_repository_impl.dart';

abstract final class ClientInjection {
  static void init() {
    // Data source
    Get.put<ClientDataSource>(
      SupabaseClientDataSource(Supabase.instance.client),
      permanent: true,
    );

    // Repository
    Get.put<ClientRepository>(
      ClientRepositoryImpl(
        dataSource: Get.find<ClientDataSource>(),
        guard: Get.find<RepositoryGuard>(),
      ),
      permanent: true,
    );

    // Use cases
    Get.lazyPut<UseCase<List<Client>, NoParams>>(
      () => FetchClients(Get.find<ClientRepository>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<Client, GetClientParams>>(
      () => GetClient(Get.find<ClientRepository>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<Client, CreateClientParams>>(
      () => CreateClient(Get.find<ClientRepository>(), Get.find<Clock>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<Client, UpdateClientParams>>(
      () => UpdateClient(Get.find<ClientRepository>(), Get.find<Clock>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<void, DeleteClientParams>>(
      () => DeleteClient(Get.find<ClientRepository>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<List<Client>, SearchClientsParams>>(
      () => SearchClients(Get.find<ClientRepository>()),
      fenix: true,
    );
  }
}
