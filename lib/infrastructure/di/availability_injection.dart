import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/repositories/repository_guard.dart';
import '../../core/utils/clock.dart';
import '../../domain/entities/availability_rule.dart';
import '../../domain/repositories/availability_repository.dart';
import '../../usecases/availability/create_availability_rule.dart';
import '../../usecases/availability/delete_availability_rule.dart';
import '../../usecases/availability/fetch_availability_rules.dart';
import '../../usecases/availability/params.dart';
import '../../usecases/availability/update_availability_rule.dart';
import '../../usecases/usecase.dart';
import '../datasources/contract/availability_data_source.dart';
import '../datasources/supabase_availability_data_source.dart';
import '../repositories/availability_repository_impl.dart';

abstract final class AvailabilityInjection {
  static void init() {
    // Data source
    Get.put<AvailabilityDataSource>(
      SupabaseAvailabilityDataSource(Supabase.instance.client),
      permanent: true,
    );

    // Repository
    Get.put<AvailabilityRepository>(
      AvailabilityRepositoryImpl(
        dataSource: Get.find<AvailabilityDataSource>(),
        guard: Get.find<RepositoryGuard>(),
      ),
      permanent: true,
    );

    // Use cases
    Get.lazyPut<UseCase<List<AvailabilityRule>, NoParams>>(
      () => FetchAvailabilityRules(Get.find<AvailabilityRepository>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<AvailabilityRule, CreateAvailabilityRuleParams>>(
      () => CreateAvailabilityRule(
        Get.find<AvailabilityRepository>(),
        Get.find<Clock>(),
      ),
      tag: 'createAvailabilityRule',
      fenix: true,
    );
    Get.lazyPut<UseCase<AvailabilityRule, UpdateAvailabilityRuleParams>>(
      () => UpdateAvailabilityRule(
        Get.find<AvailabilityRepository>(),
        Get.find<Clock>(),
      ),
      tag: 'updateAvailabilityRule',
      fenix: true,
    );
    Get.lazyPut<UseCase<void, DeleteAvailabilityRuleParams>>(
      () => DeleteAvailabilityRule(Get.find<AvailabilityRepository>()),
      fenix: true,
    );
  }
}
