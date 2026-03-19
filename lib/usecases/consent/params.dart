import '../../core/enums/consent_type.dart';

const String saveCookieConsentKey = 'cookie_consent_v1';

typedef SaveCookieConsentParams = ({Map<ConsentType, bool> choices});
