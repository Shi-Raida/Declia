import 'package:declia/core/enums/consent_type.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
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
  @override
  void toClientDetail(String id, {dynamic arguments}) {}
  @override
  void toClientEdit(String id, {dynamic arguments}) {}
  @override
  void toClientNew() {}
  @override
  void goBack() {}
}

void main() {
  late _FakeSaveCookieConsent saveConsent;
  late CookieConsentController controller;

  void makeController({bool hasExistingConsent = false}) {
    controller = CookieConsentController(
      saveCookieConsent: saveConsent,
      navigationService: _FakeNavigationService(),
      hasExistingConsent: hasExistingConsent,
    );
    controller.onInit();
  }

  setUp(() {
    saveConsent = _FakeSaveCookieConsent();
  });

  tearDown(() {
    controller.onClose();
    Get.reset();
  });

  group('CookieConsentController', () {
    group('banner visibility', () {
      test('shows banner when no consent stored', () {
        makeController(hasExistingConsent: false);
        expect(controller.showBanner.value, isTrue);
      });

      test('hides banner when consent already stored', () {
        makeController(hasExistingConsent: true);
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
