import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/logger/app_logger.dart';
import 'package:declia/core/logger/log_observer.dart';
import 'package:declia/core/logger/log_record.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/presentation/controllers/forgot_password_controller.dart';
import 'package:declia/presentation/services/navigation_service.dart';
import 'package:declia/usecases/auth/params.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

final class _FakeResetPassword extends UseCase<void, ResetPasswordParams> {
  bool called = false;
  Failure? failureToReturn;

  @override
  Future<Result<void, Failure>> call(ResetPasswordParams params) async {
    if (failureToReturn != null) {
      return Err(failureToReturn!);
    }
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

final class _FakeNavigationService implements NavigationService {
  @override
  String get currentRoute => '';
  @override
  void toLogin({String? reason}) {}
  @override
  void toHome(dynamic role) {}
  @override
  void toDashboard() {}
  @override
  void toAdminPage(String route) {}
  @override
  void toClientLogin({String? tenantSlug}) {}
  @override
  void toClientHome() {}
  @override
  void toClientRegister({String? tenantSlug}) {}
  @override
  void toClientForgotPassword() {}
  @override
  void toLegalPrivacy() {}
  @override
  void toClientDetail(String id, {dynamic arguments}) {}
  @override
  void toClientEdit(String id, {dynamic arguments}) {}
  @override
  void toClientNew() {}
  @override
  void goBack() {}
}

void main() {
  late _FakeResetPassword resetPassword;
  late ForgotPasswordController controller;

  setUp(() {
    resetPassword = _FakeResetPassword();
    controller = ForgotPasswordController(
      resetPassword,
      _FakeLogger(),
      _FakeNavigationService(),
    );
    controller.onInit();
  });

  tearDown(() {
    controller.onClose();
    Get.reset();
  });

  group('ForgotPasswordController', () {
    test('sets isSuccess on Ok result', () async {
      final result = await resetPassword((email: 'client@fleur.test'));
      expect(result, isA<Ok<void, Failure>>());
      expect(resetPassword.called, isTrue);
    });

    test('returns Err on failure', () async {
      resetPassword.failureToReturn = const PasswordResetFailedFailure(
        'Reset failed',
      );

      final result = await resetPassword((email: 'client@fleur.test'));

      expect(result, isA<Err<void, Failure>>());
      expect(
        (result as Err).error,
        const PasswordResetFailedFailure('Reset failed'),
      );
    });
  });
}
