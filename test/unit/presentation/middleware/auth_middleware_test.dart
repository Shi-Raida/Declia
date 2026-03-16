import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/core/enums/user_role.dart';
import 'package:declia/domain/entities/app_user.dart';
import 'package:declia/presentation/controllers/auth_state_controller.dart';
import 'package:declia/presentation/middleware/auth_middleware.dart';
import 'package:declia/presentation/routes/app_routes.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

const _photographer = AppUser(
  id: '00000000-0000-0000-0001-000000000001',
  email: 'photo@fleur.test',
  tenantId: '00000000-0000-0000-0000-000000000001',
  role: UserRole.photographer,
);

final class _FakeSignOut extends UseCase<void, NoParams> {
  @override
  Future<Result<void, Failure>> call(NoParams params) async => const Ok(null);
}

void main() {
  late AuthStateController authState;

  setUp(() {
    authState = AuthStateController(_FakeSignOut());
  });

  group('AuthMiddleware', () {
    test('returns null when user is authenticated', () {
      authState.setUser(_photographer);
      final middleware = AuthMiddleware(authState);

      expect(middleware.redirect('/some-route'), isNull);
    });

    test('returns login route when user is not authenticated', () {
      final middleware = AuthMiddleware(authState);

      final result = middleware.redirect('/some-route');

      expect(result, isNotNull);
      expect(result!.name, AppRoutes.login);
    });

    test(
      'returns custom redirectRoute when specified and user is unauthenticated',
      () {
        final middleware = AuthMiddleware(
          authState,
          redirectRoute: AppRoutes.clientLogin,
        );

        final result = middleware.redirect('/some-route');

        expect(result, isNotNull);
        expect(result!.name, AppRoutes.clientLogin);
      },
    );
  });
}
