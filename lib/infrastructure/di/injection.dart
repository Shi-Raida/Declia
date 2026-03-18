import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/logger/app_logger.dart';
import '../config/app_config.dart';
import 'auth_injection.dart';
import 'client_injection.dart';
import 'consent_injection.dart';
import 'core_injection.dart';
import 'tenant_injection.dart';

abstract final class Injection {
  static Future<void> init(AppConfig config) async {
    CoreInjection.init(config);

    await Supabase.initialize(
      url: config.supabaseUrl,
      anonKey: config.supabaseAnonKey,
    );

    AuthInjection.init();
    TenantInjection.init();
    ConsentInjection.init();
    ClientInjection.init();

    Get.find<AppLogger>().debug('Core services registered');
  }
}
