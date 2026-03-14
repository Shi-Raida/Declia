import 'package:declia/core/logger/log_level.dart';

class LogFilter {
  const LogFilter.development() : minimumLevel = LogLevel.trace;
  const LogFilter.staging() : minimumLevel = LogLevel.info;
  const LogFilter.production() : minimumLevel = LogLevel.warning;
  const LogFilter.test() : minimumLevel = LogLevel.error;

  final LogLevel minimumLevel;

  bool shouldLog(LogLevel level) => level >= minimumLevel;
}
