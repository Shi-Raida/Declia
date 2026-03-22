import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/core/enums/user_role.dart';
import 'package:declia/domain/entities/app_user.dart';
import 'package:declia/presentation/controllers/auth_state_controller.dart';
import 'package:declia/presentation/middleware/role_middleware.dart';
import 'package:declia/presentation/models/user_view_model.dart';
import 'package:declia/presentation/routes/app_routes.dart';
import 'package:declia/presentation/routes/route_args.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

const _photographer = AppUser(
  id: '00000000-0000-0000-0001-000000000001',
  email: 'photo@fleur.test',
  tenantId: '00000000-0000-0000-0000-000000000001',
  role: UserRole.photographer,
);

const _tech = AppUser(
  id: '00000000-0000-0000-0001-000000000004',
  email: 'tech@fleur.test',
  tenantId: '00000000-0000-0000-0000-000000000001',
  role: UserRole.tech,
);

const _client = AppUser(
  id: '00000000-0000-0000-0001-000000000002',
  email: 'client@fleur.test',
  tenantId: '00000000-0000-0000-0000-000000000001',
  role: UserRole.client,
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

  group('RoleMiddleware', () {
    test('returns null when photographer is in {photographer, tech}', () {
      authState.setUser(UserViewModel.fromEntity(_photographer));
      final middleware = RoleMiddleware(authState, {
        UserRole.photographer,
        UserRole.tech,
      });

      expect(middleware.redirect('/admin'), isNull);
    });

    test('returns null when tech user is in {photographer, tech}', () {
      authState.setUser(UserViewModel.fromEntity(_tech));
      final middleware = RoleMiddleware(authState, {
        UserRole.photographer,
        UserRole.tech,
      });

      expect(middleware.redirect('/admin'), isNull);
    });

    test(
      'redirects with unauthorizedRole when client is in {photographer, tech}',
      () {
        authState.setUser(UserViewModel.fromEntity(_client));
        final middleware = RoleMiddleware(authState, {
          UserRole.photographer,
          UserRole.tech,
        });

        final result = middleware.redirect('/admin');

        expect(result, isNotNull);
        expect(result!.name, AppRoutes.login);
        expect(result.arguments, RouteArgs.unauthorizedRole);
      },
    );

    test('redirects with unauthorizedRole when user is null', () {
      // authState has no user set — currentUser.value is null
      final middleware = RoleMiddleware(authState, {
        UserRole.photographer,
        UserRole.tech,
      });

      final result = middleware.redirect('/admin');

      expect(result, isNotNull);
      expect(result!.arguments, RouteArgs.unauthorizedRole);
    });

    test('returns null when client is in {client}', () {
      authState.setUser(UserViewModel.fromEntity(_client));
      final middleware = RoleMiddleware(authState, {UserRole.client});

      expect(middleware.redirect('/client'), isNull);
    });

    test('uses custom redirectRoute when specified', () {
      authState.setUser(UserViewModel.fromEntity(_client));
      final middleware = RoleMiddleware(authState, {
        UserRole.photographer,
        UserRole.tech,
      }, redirectRoute: AppRoutes.login);

      final result = middleware.redirect('/admin');

      expect(result, isNotNull);
      expect(result!.name, AppRoutes.login);
    });
  });
}
