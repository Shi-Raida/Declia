import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';

import '../../core/enums/consent_type.dart';

abstract interface class ConsentRepository {
  Future<Result<void, Failure>> saveConsent({
    required ConsentType consentType,
    required bool granted,
    required String anonId,
  });
}
