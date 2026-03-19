import '../../core/errors/failures.dart';
import '../../core/storage/local_storage.dart';
import '../../core/utils/result.dart';
import '../../core/utils/uuid_generator.dart';
import '../../domain/repositories/consent_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class SaveCookieConsent extends UseCase<void, SaveCookieConsentParams> {
  const SaveCookieConsent(
    this._consentRepository,
    this._localStorage,
    this._uuidGenerator,
  );

  static const String consentKey = 'cookie_consent_v1';
  static const String _anonIdKey = 'cookie_anon_id';

  final ConsentRepository _consentRepository;
  final LocalStorage _localStorage;
  final UuidGenerator _uuidGenerator;

  @override
  Future<Result<void, Failure>> call(SaveCookieConsentParams params) async {
    final anonId = _getOrCreateAnonId();
    for (final entry in params.choices.entries) {
      final result = await _consentRepository.saveConsent(
        consentType: entry.key,
        granted: entry.value,
        anonId: anonId,
      );
      if (result.isErr) return result;
    }
    _localStorage.write(consentKey, 'true');
    return const Ok(null);
  }

  String _getOrCreateAnonId() {
    final existing = _localStorage.read(_anonIdKey);
    if (existing != null) return existing;
    final id = _uuidGenerator.generate();
    _localStorage.write(_anonIdKey, id);
    return id;
  }
}
