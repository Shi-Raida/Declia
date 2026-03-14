import 'package:flutter_test/flutter_test.dart';
import 'package:declia/core/logger/log_level.dart';
import 'package:declia/infrastructure/logger/log_filter.dart';

void main() {
  group('LogFilter', () {
    group('development', () {
      final filter = const LogFilter.development();

      test('should log all levels', () {
        for (final level in LogLevel.values) {
          expect(filter.shouldLog(level), isTrue);
        }
      });

      test('minimumLevel is trace', () {
        expect(filter.minimumLevel, LogLevel.trace);
      });
    });

    group('staging', () {
      final filter = const LogFilter.staging();

      test('should not log trace and debug', () {
        expect(filter.shouldLog(LogLevel.trace), isFalse);
        expect(filter.shouldLog(LogLevel.debug), isFalse);
      });

      test('should log info and above', () {
        expect(filter.shouldLog(LogLevel.info), isTrue);
        expect(filter.shouldLog(LogLevel.warning), isTrue);
        expect(filter.shouldLog(LogLevel.error), isTrue);
        expect(filter.shouldLog(LogLevel.fatal), isTrue);
      });
    });

    group('production', () {
      final filter = const LogFilter.production();

      test('should not log trace, debug, info', () {
        expect(filter.shouldLog(LogLevel.trace), isFalse);
        expect(filter.shouldLog(LogLevel.debug), isFalse);
        expect(filter.shouldLog(LogLevel.info), isFalse);
      });

      test('should log warning and above', () {
        expect(filter.shouldLog(LogLevel.warning), isTrue);
        expect(filter.shouldLog(LogLevel.error), isTrue);
        expect(filter.shouldLog(LogLevel.fatal), isTrue);
      });
    });

    group('test', () {
      final filter = const LogFilter.test();

      test('should not log below error', () {
        expect(filter.shouldLog(LogLevel.trace), isFalse);
        expect(filter.shouldLog(LogLevel.debug), isFalse);
        expect(filter.shouldLog(LogLevel.info), isFalse);
        expect(filter.shouldLog(LogLevel.warning), isFalse);
      });

      test('should log error and fatal', () {
        expect(filter.shouldLog(LogLevel.error), isTrue);
        expect(filter.shouldLog(LogLevel.fatal), isTrue);
      });
    });
  });
}
