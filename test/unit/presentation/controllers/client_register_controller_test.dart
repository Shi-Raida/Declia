import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/logger/app_logger.dart';
import 'package:declia/core/logger/log_observer.dart';
import 'package:declia/core/logger/log_record.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/presentation/controllers/client_register_controller.dart';
import 'package:declia/presentation/services/navigation_service.dart';
import 'package:declia/usecases/auth/params.dart';
import 'package:declia/usecases/tenant/check_tenant_slug.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

final class _FakeSignUp extends UseCase<void, SignUpParams> {
  bool called = false;
  Failure? failureToReturn;

  @override
  Future<Result<void, Failure>> call(SignUpParams params) async {
    if (failureToReturn != null) {
      return Err(failureToReturn!);
    }
    called = true;
    return const Ok(null);
  }
}

final class _FakeCheckTenantSlug extends UseCase<bool, CheckTenantSlugParams> {
  bool resultToReturn;
  Failure? failureToReturn;

  _FakeCheckTenantSlug({this.resultToReturn = true});

  @override
  Future<Result<bool, Failure>> call(CheckTenantSlugParams params) async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(resultToReturn);
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
}

ClientRegisterController _makeController({
  String tenantSlug = 'fleur-de-lumiere',
  _FakeCheckTenantSlug? checkTenantSlug,
  _FakeSignUp? signUp,
}) {
  return ClientRegisterController(
    signUp ?? _FakeSignUp(),
    _FakeLogger(),
    tenantSlug,
    _FakeNavigationService(),
    checkTenantSlug ?? _FakeCheckTenantSlug(),
  );
}

void main() {
  tearDown(() {
    Get.reset();
  });

  group('ClientRegisterController — slug validation', () {
    test('isSlugValid is true after onInit with valid slug', () async {
      final checkSlug = _FakeCheckTenantSlug(resultToReturn: true);
      final controller = _makeController(checkTenantSlug: checkSlug);

      controller.onInit();
      await Future.microtask(() {});

      expect(controller.isSlugValid.value, isTrue);
      expect(controller.isValidatingSlug.value, isFalse);
    });

    test('isSlugValid is false after onInit with nonexistent slug', () async {
      final checkSlug = _FakeCheckTenantSlug(resultToReturn: false);
      final controller = _makeController(
        tenantSlug: 'nonexistent',
        checkTenantSlug: checkSlug,
      );

      controller.onInit();
      await Future.microtask(() {});

      expect(controller.isSlugValid.value, isFalse);
      expect(controller.isValidatingSlug.value, isFalse);
    });

    test('isSlugValid is false and no RPC called when slug is empty', () async {
      final checkSlug = _FakeCheckTenantSlug();
      final controller = _makeController(
        tenantSlug: '',
        checkTenantSlug: checkSlug,
      );

      controller.onInit();
      await Future.microtask(() {});

      expect(controller.isSlugValid.value, isFalse);
      expect(controller.isValidatingSlug.value, isFalse);
    });

    test('fails open (isSlugValid true) when RPC returns an error', () async {
      final checkSlug = _FakeCheckTenantSlug();
      checkSlug.failureToReturn = const RepositoryFailure('RPC error');
      final controller = _makeController(checkTenantSlug: checkSlug);

      controller.onInit();
      await Future.microtask(() {});

      expect(controller.isSlugValid.value, isTrue);
      expect(controller.isValidatingSlug.value, isFalse);
    });
  });

  group('ClientRegisterController — sign up use case', () {
    test('delegates to use case on success', () async {
      final signUp = _FakeSignUp();
      final result = await signUp((
        email: 'client@fleur.test',
        password: 'password123',
        tenantSlug: 'fleur-de-lumiere',
      ));

      expect(result, isA<Ok<void, Failure>>());
      expect(signUp.called, isTrue);
    });

    test('returns Err with EmailAlreadyInUseFailure', () async {
      final signUp = _FakeSignUp()
        ..failureToReturn =
            const EmailAlreadyInUseFailure('Email already in use');

      final result = await signUp((
        email: 'existing@fleur.test',
        password: 'password123',
        tenantSlug: 'fleur-de-lumiere',
      ));

      expect(result, isA<Err<void, Failure>>());
      expect((result as Err).error, isA<EmailAlreadyInUseFailure>());
    });

    test('returns Err with generic failure', () async {
      final signUp = _FakeSignUp()
        ..failureToReturn = const RepositoryFailure('Unexpected error');

      final result = await signUp((
        email: 'client@fleur.test',
        password: 'password123',
        tenantSlug: 'fleur-de-lumiere',
      ));

      expect(result, isA<Err<void, Failure>>());
      expect((result as Err).error, isA<RepositoryFailure>());
    });
  });
}
