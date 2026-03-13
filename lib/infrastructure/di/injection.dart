import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/datasources/auth_data_source.dart';
import '../../domain/datasources/tenant_data_source.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../../usecases/auth/get_current_user.dart';
import '../../usecases/auth/params.dart';
import '../../usecases/auth/sign_in.dart';
import '../../usecases/auth/sign_out.dart';
import '../../usecases/usecase.dart';
import '../config/app_config.dart';
import '../datasources/supabase_auth_data_source.dart';
import '../datasources/supabase_tenant_data_source.dart';
import '../repositories/auth_repository_impl.dart';
import '../repositories/tenant_repository_impl.dart';

abstract final class Injection {
  static Future<void> init(AppConfig config) async {
    Get.put(config, permanent: true);
    await Supabase.initialize(
      url: config.supabaseUrl,
      anonKey: config.supabaseAnonKey,
    );
    // Data sources (permanent)
    Get.put<AuthDataSource>(
      SupabaseAuthDataSource(Supabase.instance.client),
      permanent: true,
    );
    Get.put<TenantDataSource>(
      SupabaseTenantDataSource(Supabase.instance.client),
      permanent: true,
    );
    // Repositories (permanent)
    Get.put<AuthRepository>(
      AuthRepositoryImpl(dataSource: Get.find<AuthDataSource>()),
      permanent: true,
    );
    Get.put<TenantRepository>(
      TenantRepositoryImpl(
        dataSource: Get.find<TenantDataSource>(),
        currentUserId: () => Get.find<AuthRepository>().currentUserId,
      ),
      permanent: true,
    );
    // Use cases (lazy)
    Get.lazyPut<UseCase<AppUser, SignInParams>>(
      () => SignIn(Get.find<AuthRepository>()),
    );
    Get.lazyPut<UseCase<void, NoParams>>(
      () => SignOut(Get.find<AuthRepository>()),
    );
    Get.lazyPut<UseCase<AppUser?, NoParams>>(
      () => GetCurrentUser(Get.find<AuthRepository>()),
    );
  }
}
