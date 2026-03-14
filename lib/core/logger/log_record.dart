import 'package:declia/core/logger/log_level.dart';

class LogRecord {
  const LogRecord({
    required this.level,
    required this.message,
    required this.timestamp,
    this.error,
    this.stackTrace,
    this.metadata,
  });

  final LogLevel level;
  final String message;
  final DateTime timestamp;
  final Object? error;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? metadata;

  @override
  String toString() =>
      'LogRecord(level: $level, message: $message, timestamp: $timestamp)';
}
