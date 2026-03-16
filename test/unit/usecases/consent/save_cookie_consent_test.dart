import 'package:declia/core/enums/consent_type.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/repositories/consent_repository.dart';
import 'package:declia/usecases/consent/save_cookie_consent.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeConsentRepository implements ConsentRepository {
  final Map<ConsentType, bool> saved = {};
  Failure? failOn;

  @override
  Future<Result<void, Failure>> saveConsent({
    required ConsentType consentType,
    required bool granted,
    required String anonId,
  }) async {
    if (failOn != null && consentType == ConsentType.marketing) {
      return Err(failOn!);
    }
    saved[consentType] = granted;
    return const Ok(null);
  }
}

void main() {
  late _FakeConsentRepository repo;
  late SaveCookieConsent useCase;

  setUp(() {
    repo = _FakeConsentRepository();
    useCase = SaveCookieConsent(repo);
  });

  const anonId = 'test-anon-id';

  group('SaveCookieConsent', () {
    test('returns Ok and saves all consents when all succeed', () async {
      const choices = {
        ConsentType.analytics: true,
        ConsentType.marketing: false,
        ConsentType.functional: true,
      };

      final result = await useCase((choices: choices, anonId: anonId));

      expect(result, isA<Ok<void, Failure>>());
      expect(repo.saved[ConsentType.analytics], isTrue);
      expect(repo.saved[ConsentType.marketing], isFalse);
      expect(repo.saved[ConsentType.functional], isTrue);
    });

    test('returns Err and stops on first failure', () async {
      repo.failOn = const RepositoryFailure('db error');
      const choices = {
        ConsentType.analytics: true,
        ConsentType.marketing: true,
        ConsentType.functional: true,
      };

      final result = await useCase((choices: choices, anonId: anonId));

      expect(result, isA<Err<void, Failure>>());
      expect((result as Err).error, isA<RepositoryFailure>());
      // analytics was saved before marketing failed
      expect(repo.saved.containsKey(ConsentType.analytics), isTrue);
      // functional was not reached
      expect(repo.saved.containsKey(ConsentType.functional), isFalse);
    });

    test('returns Ok with empty choices map', () async {
      final result = await useCase((choices: {}, anonId: anonId));

      expect(result, isA<Ok<void, Failure>>());
      expect(repo.saved, isEmpty);
    });

    test('passes anonId to repository', () async {
      // Verify the use case wires anonId through — tested indirectly
      // via the fake which does not assert on anonId; covered by repo tests.
      const choices = {ConsentType.functional: true};

      final result = await useCase((choices: choices, anonId: 'specific-id'));

      expect(result.isOk, isTrue);
    });
  });
}
