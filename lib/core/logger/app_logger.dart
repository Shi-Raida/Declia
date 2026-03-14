import 'package:declia/core/logger/log_observer.dart';
import 'package:declia/core/logger/log_record.dart';

abstract interface class AppLogger {
  void trace(String message, {Map<String, dynamic>? metadata});
  void debug(String message, {Map<String, dynamic>? metadata});
  void info(String message, {Map<String, dynamic>? metadata});
  void warning(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  });
  void error(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  });
  void fatal(
    String message, {
    Object? error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  });
  void addObserver(LogObserver observer);
  void removeObserver(LogObserver observer);
  List<LogRecord> get history;
  void clearHistory();
}
