import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/logger/app_logger.dart';
import 'package:declia/core/logger/log_observer.dart';
import 'package:declia/core/logger/log_record.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/presentation/controllers/client_register_controller.dart';
import 'package:declia/usecases/auth/params.dart';
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
  late _FakeSignUp signUp;
  late ClientRegisterController controller;

  setUp(() {
    signUp = _FakeSignUp();
    controller = ClientRegisterController(
      signUp,
      _FakeLogger(),
      'fleur-de-lumiere',
    );
    controller.onInit();
  });

  tearDown(() {
    controller.onClose();
    Get.reset();
  });

  group('ClientRegisterController', () {
    test('delegates to use case on success', () async {
      final result = await signUp((
        email: 'client@fleur.test',
        password: 'password123',
        tenantSlug: 'fleur-de-lumiere',
      ));

      expect(result, isA<Ok<void, Failure>>());
      expect(signUp.called, isTrue);
    });

    test('returns Err with EmailAlreadyInUseFailure', () async {
      signUp.failureToReturn = const EmailAlreadyInUseFailure(
        'Email already in use',
      );

      final result = await signUp((
        email: 'existing@fleur.test',
        password: 'password123',
        tenantSlug: 'fleur-de-lumiere',
      ));

      expect(result, isA<Err<void, Failure>>());
      expect((result as Err).error, isA<EmailAlreadyInUseFailure>());
    });

    test('returns Err with generic failure', () async {
      signUp.failureToReturn = const RepositoryFailure('Unexpected error');

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
