import 'package:talker/talker.dart' as talker_pkg;
import 'package:declia/core/logger/app_logger.dart';
import 'package:declia/core/logger/log_level.dart';
import 'package:declia/core/logger/log_observer.dart';
import 'package:declia/core/logger/log_record.dart';
import 'package:declia/core/utils/clock.dart';
import 'package:declia/infrastructure/logger/log_filter.dart';

class TalkerLogger implements AppLogger {
  TalkerLogger({
    required LogFilter filter,
    required Clock clock,
    talker_pkg.Talker? talker,
  }) : _filter = filter,
       _clock = clock,
       _talker = talker ?? talker_pkg.Talker();

  final LogFilter _filter;
  final Clock _clock;
  final talker_pkg.Talker _talker;
  final List<LogRecord> _history = [];
  final List<LogObserver> _observers = [];

  static const int maxHistorySize = 1000;

  @override
  void trace(String message, {Map<String, dynamic>? metadata}) =>
      _log(LogLevel.trace, message, metadata: metadata);

  @override
  void debug(String message, {Map<String, dynamic>? metadata}) =>
      _log(LogLevel.debug, message, metadata: metadata);

  @override
  void info(String message, {Map<String, dynamic>? metadata}) =>
      _log(LogLevel.info, message, metadata: metadata);

  @override
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) => _log(
    LogLevel.warning,
    message,
    error: error,
    stackTrace: stackTrace,
    metadata: metadata,
  );

  @override
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) => _log(
    LogLevel.error,
    message,
    error: error,
    stackTrace: stackTrace,
    metadata: metadata,
  );

  @override
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) => _log(
    LogLevel.fatal,
    message,
    error: error,
    stackTrace: stackTrace,
    metadata: metadata,
  );

  @override
  void addObserver(LogObserver observer) => _observers.add(observer);

  @override
  void removeObserver(LogObserver observer) => _observers.remove(observer);

  @override
  List<LogRecord> get history => List.unmodifiable(_history);

  @override
  void clearHistory() => _history.clear();

  void _log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    if (!_filter.shouldLog(level)) return;

    final record = LogRecord(
      level: level,
      message: message,
      timestamp: _clock.now(),
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
    );

    // Add to history with cap
    _history.add(record);
    if (_history.length > maxHistorySize) {
      _history.removeAt(0);
    }

    // Notify observers
    for (final observer in _observers) {
      observer.onLog(record);
    }

    // Delegate to Talker
    final talkerMessage = metadata != null ? '$message | $metadata' : message;
    switch (level) {
      case LogLevel.trace:
        _talker.verbose(talkerMessage);
      case LogLevel.debug:
        _talker.debug(talkerMessage);
      case LogLevel.info:
        _talker.info(talkerMessage);
      case LogLevel.warning:
        _talker.warning(talkerMessage, error, stackTrace);
      case LogLevel.error:
        _talker.error(talkerMessage, error, stackTrace);
      case LogLevel.fatal:
        _talker.critical(talkerMessage, error, stackTrace);
    }
  }
}
