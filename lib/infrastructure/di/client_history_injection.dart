import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/repositories/repository_guard.dart';
import '../../domain/entities/client_summary_stats.dart';
import '../../domain/entities/client_history.dart';
import '../../domain/repositories/client_history_repository.dart';
import '../../usecases/client_history/fetch_client_history.dart';
import '../../usecases/client_history/fetch_summary_stats.dart';
import '../../usecases/client_history/params.dart';
import '../../usecases/usecase.dart';
import '../datasources/contract/client_history_data_source.dart';
import '../datasources/supabase_client_history_data_source.dart';
import '../repositories/client_history_repository_impl.dart';

abstract final class ClientHistoryInjection {
  static void init() {
    // Data source
    Get.put<ClientHistoryDataSource>(
      SupabaseClientHistoryDataSource(Supabase.instance.client),
      permanent: true,
    );

    // Repository
    Get.put<ClientHistoryRepository>(
      ClientHistoryRepositoryImpl(
        dataSource: Get.find<ClientHistoryDataSource>(),
        guard: Get.find<RepositoryGuard>(),
      ),
      permanent: true,
    );

    // Use cases
    Get.lazyPut<UseCase<ClientHistory, FetchClientHistoryParams>>(
      () => FetchClientHistory(Get.find<ClientHistoryRepository>()),
      fenix: true,
    );
    Get.lazyPut<
      UseCase<Map<String, ClientSummaryStats>, FetchSummaryStatsParams>
    >(
      () => FetchSummaryStats(Get.find<ClientHistoryRepository>()),
      fenix: true,
    );
  }
}
