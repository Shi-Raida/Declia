import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/repositories/repository_guard.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../../usecases/tenant/check_tenant_slug.dart';
import '../../usecases/tenant/params.dart';
import '../../usecases/usecase.dart';
import '../datasources/contract/tenant_data_source.dart';
import '../datasources/supabase_tenant_data_source.dart';
import '../repositories/tenant_repository_impl.dart';

abstract final class TenantInjection {
  static void init() {
    // Data source
    Get.put<TenantDataSource>(
      SupabaseTenantDataSource(Supabase.instance.client),
      permanent: true,
    );

    // Repository
    Get.put<TenantRepository>(
      TenantRepositoryImpl(
        dataSource: Get.find<TenantDataSource>(),
        currentUserId: () => Get.find<AuthRepository>().currentUserId,
        guard: Get.find<RepositoryGuard>(),
      ),
      permanent: true,
    );

    // Use cases
    Get.lazyPut<UseCase<bool, CheckTenantSlugParams>>(
      () => CheckTenantSlug(Get.find<TenantRepository>()),
      fenix: true,
    );
  }
}
