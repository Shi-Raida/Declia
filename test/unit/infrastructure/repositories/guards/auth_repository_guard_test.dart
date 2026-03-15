import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/logger/app_logger.dart';
import 'package:declia/core/logger/log_observer.dart';
import 'package:declia/core/logger/log_record.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/infrastructure/repositories/guards/auth_repository_guard.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeLogger implements AppLogger {
  final warnings = <String>[];

  @override
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) => warnings.add(message);

  @override
  void debug(String message, {Map<String, dynamic>? metadata}) {}
  @override
  void info(String message, {Map<String, dynamic>? metadata}) {}
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
  late _FakeLogger logger;
  late AuthRepositoryGuard guard;

  setUp(() {
    logger = _FakeLogger();
    guard = AuthRepositoryGuard(logger);
  });

  group('AuthRepositoryGuard', () {
    test('returns Ok on success', () async {
      final result = await guard(() async => 42, method: 'testMethod');
      expect(result, const Ok<int, Failure>(42));
    });

    test('returns Err on AppException', () async {
      final result = await guard<int>(
        () async => throw const InvalidCredentialsException(),
        method: 'signIn',
      );
      expect(result, isA<Err<int, Failure>>());
      expect(
        (result as Err).error,
        const InvalidCredentialsFailure('Invalid email or password'),
      );
    });

    test('logs warning on AppException', () async {
      await guard<int>(
        () async => throw const NetworkException('timeout'),
        method: 'signIn',
      );
      expect(logger.warnings, ['signIn failed']);
    });

    test('does not catch non-AppException errors', () async {
      expect(
        () => guard<int>(
          () async => throw Exception('unexpected'),
          method: 'testMethod',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
