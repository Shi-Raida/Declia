import 'package:declia/core/logger/log_record.dart';

abstract interface class LogObserver {
  void onLog(LogRecord record);
}
