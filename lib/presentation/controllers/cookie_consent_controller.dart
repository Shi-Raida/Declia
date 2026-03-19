import 'package:get/get.dart';

import '../../core/enums/consent_type.dart';
import '../../usecases/consent/params.dart';
import '../../usecases/usecase.dart';
import '../services/navigation_service.dart';

final class CookieConsentController extends GetxController {
  CookieConsentController({
    required UseCase<void, SaveCookieConsentParams> saveCookieConsent,
    required NavigationService navigationService,
    required bool hasExistingConsent,
  }) : _saveCookieConsent = saveCookieConsent,
       _nav = navigationService,
       _hasExistingConsent = hasExistingConsent;

  final UseCase<void, SaveCookieConsentParams> _saveCookieConsent;
  final NavigationService _nav;
  final bool _hasExistingConsent;

  final showBanner = false.obs;
  final showCustomize = false.obs;
  final choices = <ConsentType, bool>{
    ConsentType.analytics: false,
    ConsentType.marketing: false,
    ConsentType.functional: true,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    if (!_hasExistingConsent) {
      showBanner.value = true;
    }
  }

  Future<void> acceptAll() async {
    final all = {for (final t in ConsentType.values) t: true};
    await _saveChoices(all);
  }

  Future<void> refuseAll() async {
    final none = {for (final t in ConsentType.values) t: false};
    await _saveChoices(none);
  }

  Future<void> saveCustom() async {
    await _saveChoices(Map.of(choices));
  }

  void setChoice(ConsentType type, {required bool value}) {
    choices[type] = value;
  }

  void openPrivacyPolicy() => _nav.toLegalPrivacy();

  void toggleCustomize() {
    showCustomize.value = !showCustomize.value;
  }

  Future<void> _saveChoices(Map<ConsentType, bool> choicesMap) async {
    await _saveCookieConsent((choices: choicesMap));
    showBanner.value = false;
    showCustomize.value = false;
  }
}
