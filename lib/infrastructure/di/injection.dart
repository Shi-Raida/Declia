import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;

import '../datasources/contract/auth_data_source.dart';
import '../datasources/contract/consent_data_source.dart';
import '../datasources/contract/tenant_data_source.dart';
import '../../core/enums/environment.dart';
import '../../core/logger/app_logger.dart';
import '../../core/storage/local_storage.dart';
import '../../core/utils/clock.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/consent_repository.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../../usecases/auth/get_current_user.dart';
import '../../usecases/auth/params.dart';
import '../../usecases/auth/reset_password.dart';
import '../../usecases/auth/sign_in.dart';
import '../../usecases/auth/sign_out.dart';
import '../../usecases/auth/sign_up.dart';
import '../../usecases/consent/params.dart';
import '../../usecases/consent/save_cookie_consent.dart';
import '../../usecases/usecase.dart';
import '../clock/system_clock.dart';
import '../config/app_config.dart';
import '../datasources/supabase_auth_data_source.dart';
import '../datasources/supabase_consent_data_source.dart';
import '../datasources/supabase_tenant_data_source.dart';
import '../logger/log_filter.dart';
import '../logger/talker_logger.dart';
import '../repositories/auth_repository_impl.dart';
import '../repositories/consent_repository_impl.dart';
import '../../core/repositories/repository_guard.dart';
import '../repositories/guards/auth_repository_guard.dart';
import '../repositories/tenant_repository_impl.dart';
import '../storage/web_local_storage.dart';

abstract final class Injection {
  static Future<void> init(AppConfig config) async {
    Get.put(config, permanent: true);

    // Clock
    Get.put<Clock>(const SystemClock(), permanent: true);

    // Logger
    final logFilter = switch (config.environment) {
      Environment.development => const LogFilter.development(),
      Environment.staging => const LogFilter.staging(),
      Environment.production => const LogFilter.production(),
      Environment.test => const LogFilter.test(),
    };
    Get.put<AppLogger>(
      TalkerLogger(filter: logFilter, clock: Get.find<Clock>()),
      permanent: true,
    );
    Get.find<AppLogger>().info(
      'Initializing dependencies',
      metadata: {'environment': config.environment.name},
    );

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
    // Guards
    Get.put<RepositoryGuard>(
      AuthRepositoryGuard(Get.find<AppLogger>()),
      permanent: true,
    );
    // Repositories (permanent)
    Get.put<AuthRepository>(
      AuthRepositoryImpl(
        dataSource: Get.find<AuthDataSource>(),
        guard: Get.find<RepositoryGuard>(),
      ),
      permanent: true,
    );
    Get.put<TenantRepository>(
      TenantRepositoryImpl(
        dataSource: Get.find<TenantDataSource>(),
        currentUserId: () => Get.find<AuthRepository>().currentUserId,
        guard: Get.find<RepositoryGuard>(),
      ),
      permanent: true,
    );
    // Consent
    Get.put<ConsentDataSource>(
      SupabaseConsentDataSource(Supabase.instance.client),
      permanent: true,
    );
    Get.put<LocalStorage>(const WebLocalStorage(), permanent: true);
    Get.put<ConsentRepository>(
      ConsentRepositoryImpl(
        dataSource: Get.find<ConsentDataSource>(),
        guard: Get.find<RepositoryGuard>(),
      ),
      permanent: true,
    );
    // Use cases (lazy, fenix: recreated after disposal)
    Get.lazyPut<UseCase<AppUser, SignInParams>>(
      () => SignIn(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<void, NoParams>>(
      () => SignOut(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<AppUser?, NoParams>>(
      () => GetCurrentUser(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<void, SignUpParams>>(
      () => SignUp(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<void, ResetPasswordParams>>(
      () => ResetPassword(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut<UseCase<void, SaveCookieConsentParams>>(
      () => SaveCookieConsent(Get.find<ConsentRepository>()),
      fenix: true,
    );

    Get.find<AppLogger>().debug('Core services registered');
  }
}
