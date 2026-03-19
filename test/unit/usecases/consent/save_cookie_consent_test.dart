import 'package:declia/core/enums/consent_type.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/storage/local_storage.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/core/utils/uuid_generator.dart';
import 'package:declia/domain/repositories/consent_repository.dart';
import 'package:declia/usecases/consent/params.dart';
import 'package:declia/usecases/consent/save_cookie_consent.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeConsentRepository implements ConsentRepository {
  final Map<ConsentType, bool> saved = {};
  final List<String> anonIds = [];
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
    anonIds.add(anonId);
    return const Ok(null);
  }
}

final class _FakeLocalStorage implements LocalStorage {
  final Map<String, String> _store = {};

  @override
  String? read(String key) => _store[key];

  @override
  void write(String key, String value) => _store[key] = value;

  @override
  void delete(String key) => _store.remove(key);
}

final class _FakeUuidGenerator implements UuidGenerator {
  int _counter = 0;

  @override
  String generate() {
    _counter++;
    return '00000000-0000-4000-8000-00000000000$_counter';
  }
}

void main() {
  late _FakeConsentRepository repo;
  late _FakeLocalStorage localStorage;
  late _FakeUuidGenerator uuidGenerator;
  late SaveCookieConsent useCase;

  setUp(() {
    repo = _FakeConsentRepository();
    localStorage = _FakeLocalStorage();
    uuidGenerator = _FakeUuidGenerator();
    useCase = SaveCookieConsent(repo, localStorage, uuidGenerator);
  });

  group('SaveCookieConsent', () {
    group('consent persistence', () {
      test('returns Ok and saves all consents when all succeed', () async {
        const choices = {
          ConsentType.analytics: true,
          ConsentType.marketing: false,
          ConsentType.functional: true,
        };

        final result = await useCase((choices: choices));

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

        final result = await useCase((choices: choices));

        expect(result, isA<Err<void, Failure>>());
        expect((result as Err).error, isA<RepositoryFailure>());
        expect(repo.saved.containsKey(ConsentType.analytics), isTrue);
        expect(repo.saved.containsKey(ConsentType.functional), isFalse);
      });

      test('returns Ok with empty choices map', () async {
        final result = await useCase((choices: {}));

        expect(result, isA<Ok<void, Failure>>());
        expect(repo.saved, isEmpty);
      });

      test('writes consent flag to localStorage on success', () async {
        await useCase((choices: {ConsentType.functional: true}));

        expect(localStorage.read(saveCookieConsentKey), 'true');
      });

      test('does not write consent flag when repo fails', () async {
        repo.failOn = const RepositoryFailure('db error');
        await useCase((
          choices: {ConsentType.analytics: true, ConsentType.marketing: true},
        ));

        expect(localStorage.read(saveCookieConsentKey), isNull);
      });
    });

    group('anon ID management', () {
      test('creates a new anonId when none exists', () async {
        await useCase((choices: {ConsentType.functional: true}));

        final anonId = localStorage.read('cookie_anon_id');
        expect(anonId, isNotNull);
        expect(anonId, isNotEmpty);
      });

      test('reuses existing anonId from localStorage', () async {
        localStorage.write('cookie_anon_id', 'existing-anon-id');

        await useCase((choices: {ConsentType.functional: true}));

        expect(localStorage.read('cookie_anon_id'), 'existing-anon-id');
        expect(repo.anonIds.first, 'existing-anon-id');
      });

      test('passes anonId to all repo calls', () async {
        const choices = {
          ConsentType.analytics: true,
          ConsentType.functional: true,
        };

        await useCase((choices: choices));

        expect(repo.anonIds.length, 2);
        expect(repo.anonIds.toSet().length, 1); // all the same id
      });
    });
  });
}
