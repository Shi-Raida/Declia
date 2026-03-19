import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide LocalStorage;

import '../../core/repositories/repository_guard.dart';
import '../../core/storage/local_storage.dart';
import '../../core/utils/uuid_generator.dart';
import '../../domain/repositories/consent_repository.dart';
import '../../usecases/consent/params.dart';
import '../../usecases/consent/save_cookie_consent.dart';
import '../../usecases/usecase.dart';
import '../datasources/contract/consent_data_source.dart';
import '../datasources/supabase_consent_data_source.dart';
import '../repositories/consent_repository_impl.dart';

abstract final class ConsentInjection {
  static void init() {
    // Data source
    Get.put<ConsentDataSource>(
      SupabaseConsentDataSource(Supabase.instance.client),
      permanent: true,
    );

    // Repository
    Get.put<ConsentRepository>(
      ConsentRepositoryImpl(
        dataSource: Get.find<ConsentDataSource>(),
        guard: Get.find<RepositoryGuard>(),
      ),
      permanent: true,
    );

    // Use cases
    Get.lazyPut<UseCase<void, SaveCookieConsentParams>>(
      () => SaveCookieConsent(
        Get.find<ConsentRepository>(),
        Get.find<LocalStorage>(),
        Get.find<UuidGenerator>(),
      ),
      fenix: true,
    );
  }
}
