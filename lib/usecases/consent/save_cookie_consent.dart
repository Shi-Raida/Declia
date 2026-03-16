import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/consent_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class SaveCookieConsent extends UseCase<void, SaveCookieConsentParams> {
  const SaveCookieConsent(this._consentRepository);

  final ConsentRepository _consentRepository;

  @override
  Future<Result<void, Failure>> call(SaveCookieConsentParams params) async {
    for (final entry in params.choices.entries) {
      final result = await _consentRepository.saveConsent(
        consentType: entry.key,
        granted: entry.value,
        anonId: params.anonId,
      );
      if (result.isErr) return result;
    }
    return const Ok(null);
  }
}
