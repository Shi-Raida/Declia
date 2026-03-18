import 'package:declia/core/enums/consent_type.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/storage/local_storage.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/core/utils/uuid_generator.dart';
import 'package:declia/presentation/controllers/cookie_consent_controller.dart';
import 'package:declia/presentation/services/navigation_service.dart';
import 'package:declia/usecases/consent/params.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

final class _FakeSaveCookieConsent
    extends UseCase<void, SaveCookieConsentParams> {
  SaveCookieConsentParams? lastParams;
  bool shouldFail = false;

  @override
  Future<Result<void, Failure>> call(SaveCookieConsentParams params) async {
    lastParams = params;
    if (shouldFail) return const Err(RepositoryFailure('save failed'));
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

final class _FakeNavigationService implements NavigationService {
  @override
  String get currentRoute => '';
  @override
  void toLogin({String? reason}) {}
  @override
  void toHome(dynamic role) {}
  @override
  void toDashboard() {}
  @override
  void toAdminPage(String route) {}
  @override
  void toClientLogin({String? tenantSlug}) {}
  @override
  void toClientHome() {}
  @override
  void toClientRegister({String? tenantSlug}) {}
  @override
  void toClientForgotPassword() {}
  @override
  void toLegalPrivacy() {}
}

void main() {
  late _FakeSaveCookieConsent saveConsent;
  late _FakeLocalStorage localStorage;
  late CookieConsentController controller;

  void makeController() {
    controller = CookieConsentController(
      saveCookieConsent: saveConsent,
      localStorage: localStorage,
      navigationService: _FakeNavigationService(),
      uuidGenerator: _FakeUuidGenerator(),
    );
    controller.onInit();
  }

  setUp(() {
    saveConsent = _FakeSaveCookieConsent();
    localStorage = _FakeLocalStorage();
  });

  tearDown(() {
    controller.onClose();
    Get.reset();
  });

  group('CookieConsentController', () {
    group('banner visibility', () {
      test('shows banner when no consent stored', () {
        makeController();
        expect(controller.showBanner.value, isTrue);
      });

      test('hides banner when consent already stored', () {
        localStorage.write('cookie_consent_v1', 'true');
        makeController();
        expect(controller.showBanner.value, isFalse);
      });
    });

    group('acceptAll', () {
      test('saves all consent types as true', () async {
        makeController();
        await controller.acceptAll();

        expect(saveConsent.lastParams, isNotNull);
        for (final type in ConsentType.values) {
          expect(saveConsent.lastParams!.choices[type], isTrue);
        }
      });

      test('hides banner after accepting', () async {
        makeController();
        await controller.acceptAll();

        expect(controller.showBanner.value, isFalse);
      });

      test('writes consent key to localStorage', () async {
        makeController();
        await controller.acceptAll();

        expect(localStorage.read('cookie_consent_v1'), 'true');
      });

      test('creates and persists anonId in localStorage', () async {
        makeController();
        await controller.acceptAll();

        final anonId = localStorage.read('cookie_anon_id');
        expect(anonId, isNotNull);
        expect(anonId, isNotEmpty);
        expect(anonId!.split('-').length, 5);
      });

      test('reuses existing anonId on second consent save', () async {
        localStorage.write('cookie_anon_id', 'existing-anon-id');
        makeController();
        await controller.acceptAll();

        expect(saveConsent.lastParams!.anonId, 'existing-anon-id');
      });
    });

    group('refuseAll', () {
      test('saves all consent types as false', () async {
        makeController();
        await controller.refuseAll();

        expect(saveConsent.lastParams, isNotNull);
        for (final type in ConsentType.values) {
          expect(saveConsent.lastParams!.choices[type], isFalse);
        }
      });

      test('hides banner after refusing', () async {
        makeController();
        await controller.refuseAll();

        expect(controller.showBanner.value, isFalse);
      });
    });

    group('saveCustom', () {
      test('saves current choices', () async {
        makeController();
        controller.setChoice(ConsentType.analytics, value: true);
        controller.setChoice(ConsentType.marketing, value: false);
        controller.setChoice(ConsentType.functional, value: true);

        await controller.saveCustom();

        expect(saveConsent.lastParams!.choices[ConsentType.analytics], isTrue);
        expect(saveConsent.lastParams!.choices[ConsentType.marketing], isFalse);
        expect(saveConsent.lastParams!.choices[ConsentType.functional], isTrue);
      });

      test('hides banner after saving custom preferences', () async {
        makeController();
        await controller.saveCustom();

        expect(controller.showBanner.value, isFalse);
      });

      test('hides customize panel after saving', () async {
        makeController();
        controller.toggleCustomize();
        expect(controller.showCustomize.value, isTrue);

        await controller.saveCustom();

        expect(controller.showCustomize.value, isFalse);
      });
    });

    group('toggleCustomize', () {
      test('toggles showCustomize', () {
        makeController();
        expect(controller.showCustomize.value, isFalse);

        controller.toggleCustomize();
        expect(controller.showCustomize.value, isTrue);

        controller.toggleCustomize();
        expect(controller.showCustomize.value, isFalse);
      });
    });

    group('setChoice', () {
      test('updates the choices map', () {
        makeController();
        controller.setChoice(ConsentType.analytics, value: true);

        expect(controller.choices[ConsentType.analytics], isTrue);
      });
    });
  });
}
