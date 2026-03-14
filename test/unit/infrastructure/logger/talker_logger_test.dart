import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:talker/talker.dart' as talker_pkg;
import 'package:declia/core/logger/log_level.dart';
import 'package:declia/core/logger/log_observer.dart';
import 'package:declia/core/logger/log_record.dart';
import 'package:declia/core/utils/clock.dart';
import 'package:declia/infrastructure/logger/log_filter.dart';
import 'package:declia/infrastructure/logger/talker_logger.dart';

class MockTalker extends Mock implements talker_pkg.Talker {}

class MockLogObserver extends Mock implements LogObserver {}

class FakeLogRecord extends Fake implements LogRecord {}

class FakeClock implements Clock {
  FakeClock(this._fixed);
  final DateTime _fixed;

  @override
  DateTime now() => _fixed;
}

void main() {
  late MockTalker mockTalker;
  late TalkerLogger logger;
  late FakeClock fakeClock;

  final fixedTime = DateTime(2024, 1, 15, 10, 30);

  setUpAll(() {
    registerFallbackValue(FakeLogRecord());
  });

  setUp(() {
    mockTalker = MockTalker();
    fakeClock = FakeClock(fixedTime);
    logger = TalkerLogger(
      filter: const LogFilter.development(),
      clock: fakeClock,
      talker: mockTalker,
    );
  });

  group('TalkerLogger', () {
    group('log methods', () {
      test('trace adds to history and delegates to talker.verbose', () {
        logger.trace('trace message');

        expect(logger.history, hasLength(1));
        expect(logger.history.first.level, LogLevel.trace);
        expect(logger.history.first.message, 'trace message');
        verify(() => mockTalker.verbose('trace message')).called(1);
      });

      test('debug adds to history and delegates to talker.debug', () {
        logger.debug('debug message');

        expect(logger.history, hasLength(1));
        expect(logger.history.first.level, LogLevel.debug);
        expect(logger.history.first.message, 'debug message');
        verify(() => mockTalker.debug('debug message')).called(1);
      });

      test('info adds to history and delegates to talker.info', () {
        logger.info('info message');

        expect(logger.history, hasLength(1));
        expect(logger.history.first.level, LogLevel.info);
        expect(logger.history.first.message, 'info message');
        verify(() => mockTalker.info('info message')).called(1);
      });

      test('warning adds to history and delegates to talker.warning', () {
        final error = Exception('test error');
        final stackTrace = StackTrace.current;

        logger.warning('warning message', error: error, stackTrace: stackTrace);

        expect(logger.history, hasLength(1));
        expect(logger.history.first.level, LogLevel.warning);
        expect(logger.history.first.message, 'warning message');
        expect(logger.history.first.error, error);
        expect(logger.history.first.stackTrace, stackTrace);
        verify(
          () => mockTalker.warning('warning message', error, stackTrace),
        ).called(1);
      });

      test('error adds to history and delegates to talker.error', () {
        final error = Exception('test error');
        final stackTrace = StackTrace.current;

        logger.error('error message', error: error, stackTrace: stackTrace);

        expect(logger.history, hasLength(1));
        expect(logger.history.first.level, LogLevel.error);
        expect(logger.history.first.message, 'error message');
        expect(logger.history.first.error, error);
        expect(logger.history.first.stackTrace, stackTrace);
        verify(
          () => mockTalker.error('error message', error, stackTrace),
        ).called(1);
      });

      test('fatal adds to history and delegates to talker.critical', () {
        final error = Exception('fatal error');
        final stackTrace = StackTrace.current;

        logger.fatal('fatal message', error: error, stackTrace: stackTrace);

        expect(logger.history, hasLength(1));
        expect(logger.history.first.level, LogLevel.fatal);
        expect(logger.history.first.message, 'fatal message');
        expect(logger.history.first.error, error);
        expect(logger.history.first.stackTrace, stackTrace);
        verify(
          () => mockTalker.critical('fatal message', error, stackTrace),
        ).called(1);
      });
    });

    group('filtering', () {
      test('filtered logs do not appear in history', () {
        final filteredLogger = TalkerLogger(
          filter: const LogFilter.production(),
          clock: fakeClock,
          talker: mockTalker,
        );

        filteredLogger.trace('should be filtered');
        filteredLogger.debug('should be filtered');
        filteredLogger.info('should be filtered');

        expect(filteredLogger.history, isEmpty);
        verifyNever(() => mockTalker.verbose(any()));
        verifyNever(() => mockTalker.debug(any()));
        verifyNever(() => mockTalker.info(any()));
      });

      test('logs at or above minimum level are kept', () {
        final filteredLogger = TalkerLogger(
          filter: const LogFilter.production(),
          clock: fakeClock,
          talker: mockTalker,
        );

        filteredLogger.warning('warning');
        filteredLogger.error('error');
        filteredLogger.fatal('fatal');

        expect(filteredLogger.history, hasLength(3));
      });
    });

    group('metadata', () {
      test('metadata is captured in LogRecord', () {
        final metadata = {'key': 'value', 'count': 42};

        logger.info('with metadata', metadata: metadata);

        expect(logger.history.first.metadata, metadata);
      });

      test('metadata is appended to talker message', () {
        final metadata = {'key': 'value'};

        logger.info('with metadata', metadata: metadata);

        verify(() => mockTalker.info('with metadata | {key: value}')).called(1);
      });
    });

    group('observers', () {
      test('observer is notified on log', () {
        final observer = MockLogObserver();
        logger.addObserver(observer);

        logger.info('test message');

        verify(() => observer.onLog(any())).called(1);
      });

      test('multiple observers are notified', () {
        final observer1 = MockLogObserver();
        final observer2 = MockLogObserver();
        logger
          ..addObserver(observer1)
          ..addObserver(observer2);

        logger.info('test message');

        verify(() => observer1.onLog(any())).called(1);
        verify(() => observer2.onLog(any())).called(1);
      });

      test('removed observer is not notified', () {
        final observer = MockLogObserver();
        logger.addObserver(observer);
        logger.removeObserver(observer);

        logger.info('test message');

        verifyNever(() => observer.onLog(any()));
      });
    });

    group('history', () {
      test('history returns unmodifiable list', () {
        logger.info('test');

        expect(
          () => logger.history.add(
            LogRecord(
              level: LogLevel.info,
              message: 'injected',
              timestamp: DateTime.now(),
            ),
          ),
          throwsUnsupportedError,
        );
      });

      test('clearHistory removes all entries', () {
        logger.info('message 1');
        logger.info('message 2');
        logger.info('message 3');

        expect(logger.history, hasLength(3));

        logger.clearHistory();

        expect(logger.history, isEmpty);
      });

      test(
        'history cap removes oldest entry when exceeding maxHistorySize',
        () {
          for (var i = 0; i < TalkerLogger.maxHistorySize + 1; i++) {
            logger.info('message $i');
          }

          expect(logger.history, hasLength(TalkerLogger.maxHistorySize));
          expect(logger.history.first.message, 'message 1');
          expect(
            logger.history.last.message,
            'message ${TalkerLogger.maxHistorySize}',
          );
        },
      );
    });

    group('error and stackTrace capture', () {
      test('error is captured in LogRecord', () {
        final error = Exception('test error');

        logger.error('error occurred', error: error);

        expect(logger.history.first.error, error);
      });

      test('stackTrace is captured in LogRecord', () {
        final stackTrace = StackTrace.current;

        logger.error('error occurred', stackTrace: stackTrace);

        expect(logger.history.first.stackTrace, stackTrace);
      });

      test('null error and stackTrace are handled', () {
        logger.error('error without details');

        expect(logger.history.first.error, isNull);
        expect(logger.history.first.stackTrace, isNull);
      });
    });

    group('timestamp', () {
      test('LogRecord timestamp comes from Clock', () {
        logger.info('test');

        expect(logger.history.first.timestamp, equals(fixedTime));
      });
    });
  });
}
