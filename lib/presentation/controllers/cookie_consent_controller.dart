import 'package:get/get.dart';

import '../../core/enums/consent_type.dart';
import '../../core/storage/local_storage.dart';
import '../../core/utils/uuid_generator.dart';
import '../../usecases/consent/params.dart';
import '../../usecases/usecase.dart';
import '../services/navigation_service.dart';

final class CookieConsentController extends GetxController {
  CookieConsentController({
    required UseCase<void, SaveCookieConsentParams> saveCookieConsent,
    required LocalStorage localStorage,
    required NavigationService navigationService,
    required UuidGenerator uuidGenerator,
  }) : _saveCookieConsent = saveCookieConsent,
       _localStorage = localStorage,
       _nav = navigationService,
       _uuidGenerator = uuidGenerator;

  static const String _consentKey = 'cookie_consent_v1';
  static const String _anonIdKey = 'cookie_anon_id';

  final UseCase<void, SaveCookieConsentParams> _saveCookieConsent;
  final LocalStorage _localStorage;
  final NavigationService _nav;
  final UuidGenerator _uuidGenerator;

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
    if (_localStorage.read(_consentKey) == null) {
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
    final anonId = _getOrCreateAnonId();
    await _saveCookieConsent((choices: choicesMap, anonId: anonId));
    _localStorage.write(_consentKey, 'true');
    showBanner.value = false;
    showCustomize.value = false;
  }

  String _getOrCreateAnonId() {
    final existing = _localStorage.read(_anonIdKey);
    if (existing != null) return existing;
    final id = _uuidGenerator.generate();
    _localStorage.write(_anonIdKey, id);
    return id;
  }
}
