import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/logger/app_logger.dart';
import '../../core/repositories/repository_guard.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../usecases/auth/get_current_user.dart';
import '../../usecases/auth/params.dart';
import '../../usecases/auth/reset_password.dart';
import '../../usecases/auth/sign_in.dart';
import '../../usecases/auth/sign_out.dart';
import '../../usecases/auth/sign_up.dart';
import '../../usecases/usecase.dart';
import '../datasources/contract/auth_data_source.dart';
import '../datasources/supabase_auth_data_source.dart';
import '../repositories/auth_repository_impl.dart';
import '../repositories/guards/auth_repository_guard.dart';

abstract final class AuthInjection {
  static void init() {
    // Guard
    Get.put<RepositoryGuard>(
      AuthRepositoryGuard(Get.find<AppLogger>()),
      permanent: true,
    );

    // Data source
    Get.put<AuthDataSource>(
      SupabaseAuthDataSource(Supabase.instance.client),
      permanent: true,
    );

    // Repository
    Get.put<AuthRepository>(
      AuthRepositoryImpl(
        dataSource: Get.find<AuthDataSource>(),
        guard: Get.find<RepositoryGuard>(),
      ),
      permanent: true,
    );

    // Use cases
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
  }
}
