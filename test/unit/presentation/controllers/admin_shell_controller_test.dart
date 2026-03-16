import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/logger/app_logger.dart';
import 'package:declia/core/logger/log_observer.dart';
import 'package:declia/core/logger/log_record.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/presentation/controllers/admin_shell_controller.dart';
import 'package:declia/presentation/controllers/auth_state_controller.dart';
import 'package:declia/presentation/routes/app_routes.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/mocks.dart';

final class _FakeSignOut extends UseCase<void, NoParams> {
  bool called = false;

  @override
  Future<Result<void, Failure>> call(NoParams params) async {
    called = true;
    return const Ok(null);
  }
}

final class _FakeLogger implements AppLogger {
  @override
  void debug(String message, {Map<String, dynamic>? metadata}) {}
  @override
  void info(String message, {Map<String, dynamic>? metadata}) {}
  @override
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {}
  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {}
  @override
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {}
  @override
  void trace(String message, {Map<String, dynamic>? metadata}) {}
  @override
  void addObserver(LogObserver observer) {}
  @override
  void removeObserver(LogObserver observer) {}
  @override
  List<LogRecord> get history => [];
  @override
  void clearHistory() {}
}

void main() {
  late _FakeSignOut signOut;
  late MockNavigationService nav;
  late AuthStateController authState;
  late AdminShellController controller;

  setUp(() {
    signOut = _FakeSignOut();
    nav = MockNavigationService();
    authState = AuthStateController(signOut);
    controller = AdminShellController(authState, nav, _FakeLogger());
    when(() => nav.currentRoute).thenReturn('');
    controller.onInit();
  });

  tearDown(() {
    controller.onClose();
    Get.reset();
  });

  group('AdminShellController', () {
    group('navigateTo', () {
      test('updates currentRoute', () {
        controller.navigateTo(AppRoutes.adminClients);

        expect(controller.currentRoute.value, AppRoutes.adminClients);
      });

      test('calls navigation service with the given route', () {
        controller.navigateTo(AppRoutes.adminClients);

        verify(() => nav.toAdminPage(AppRoutes.adminClients)).called(1);
      });

      test('updates currentRoute on each navigation', () {
        controller.navigateTo(AppRoutes.adminClients);
        expect(controller.currentRoute.value, AppRoutes.adminClients);

        controller.navigateTo(AppRoutes.adminSettings);
        expect(controller.currentRoute.value, AppRoutes.adminSettings);
      });
    });

    group('logout', () {
      test('delegates sign out to auth state', () async {
        await controller.logout();

        expect(signOut.called, isTrue);
      });

      test('calls toLogin on navigation service', () async {
        await controller.logout();

        verify(() => nav.toLogin()).called(1);
      });
    });

    group('currentUser', () {
      test('delegates to AuthStateController', () {
        expect(controller.currentUser, same(authState.currentUser));
      });
    });
  });
}
