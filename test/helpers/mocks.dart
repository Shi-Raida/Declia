import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/logger/app_logger.dart';
import 'package:declia/core/repositories/repository_guard.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/app_user.dart';
import 'package:declia/domain/repositories/auth_repository.dart';
import 'package:declia/domain/repositories/tenant_repository.dart';
import 'package:declia/infrastructure/datasources/contract/auth_data_source.dart';
import 'package:declia/infrastructure/datasources/contract/tenant_data_source.dart';
import 'package:declia/presentation/services/navigation_service.dart';
import 'package:declia/usecases/auth/params.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLogger extends Mock implements AppLogger {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTenantRepository extends Mock implements TenantRepository {}

class MockAuthDataSource extends Mock implements AuthDataSource {}

class MockTenantDataSource extends Mock implements TenantDataSource {}

class MockNavigationService extends Mock implements NavigationService {}

// Use cases mocked against the abstract UseCase interface (concrete classes are final)
class MockSignIn extends Mock implements UseCase<AppUser, SignInParams> {}

class MockSignOut extends Mock implements UseCase<void, NoParams> {}

class MockGetCurrentUser extends Mock implements UseCase<AppUser?, NoParams> {}

class MockSignUp extends Mock implements UseCase<void, SignUpParams> {}

class MockResetPassword extends Mock
    implements UseCase<void, ResetPasswordParams> {}

/// A manual guard implementation that can be toggled between success and failure.
final class MockRepositoryGuard implements RepositoryGuard {
  bool isOnline = true;
  Failure? failureOverride;

  @override
  Future<Result<T, Failure>> call<T>(
    Future<T> Function() action, {
    required String method,
  }) async {
    if (!isOnline) {
      return const Err(NetworkFailure('No internet connection'));
    }
    if (failureOverride != null) {
      return Err(failureOverride!);
    }
    try {
      return Ok(await action());
    } on AppException catch (e) {
      return Err(Failure.fromException(e));
    }
  }
}
