import 'package:declia/core/storage/local_storage.dart';
import 'package:declia/usecases/consent/has_existing_consent.dart';
import 'package:declia/usecases/consent/params.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeLocalStorage implements LocalStorage {
  final Map<String, String> _store = {};

  void put(String key, String value) => _store[key] = value;

  @override
  String? read(String key) => _store[key];

  @override
  void write(String key, String value) => _store[key] = value;

  @override
  void delete(String key) => _store.remove(key);
}

void main() {
  group('HasExistingConsent', () {
    test('returns true when consent key exists in storage', () async {
      final storage = _FakeLocalStorage()..put(saveCookieConsentKey, 'true');
      final useCase = HasExistingConsent(storage);

      final result = await useCase(const NoParams());

      expect(result.fold(ok: (v) => v, err: (_) => false), isTrue);
    });

    test('returns false when consent key is absent', () async {
      final storage = _FakeLocalStorage();
      final useCase = HasExistingConsent(storage);

      final result = await useCase(const NoParams());

      expect(result.fold(ok: (v) => v, err: (_) => true), isFalse);
    });
  });
}
