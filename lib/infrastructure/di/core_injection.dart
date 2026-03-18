import 'package:get/get.dart';

import '../../core/enums/environment.dart';
import '../../core/logger/app_logger.dart';
import '../../core/storage/local_storage.dart';
import '../../core/utils/clock.dart';
import '../../core/utils/uuid_generator.dart';
import '../clock/system_clock.dart';
import '../config/app_config.dart';
import '../logger/log_filter.dart';
import '../logger/talker_logger.dart';
import '../storage/web_local_storage.dart';
import '../uuid/uuid_v4_generator.dart';

abstract final class CoreInjection {
  static void init(AppConfig config) {
    Get.put(config, permanent: true);

    // Clock
    Get.put<Clock>(const SystemClock(), permanent: true);

    // UUID
    Get.put<UuidGenerator>(const UuidV4Generator(), permanent: true);

    // Logger
    final logFilter = switch (config.environment) {
      Environment.development => const LogFilter.development(),
      Environment.staging => const LogFilter.staging(),
      Environment.production => const LogFilter.production(),
      Environment.test => const LogFilter.test(),
    };
    Get.put<AppLogger>(
      TalkerLogger(filter: logFilter, clock: Get.find<Clock>()),
      permanent: true,
    );
    Get.find<AppLogger>().info(
      'Initializing dependencies',
      metadata: {'environment': config.environment.name},
    );

    // Storage
    Get.put<LocalStorage>(const WebLocalStorage(), permanent: true);
  }
}
