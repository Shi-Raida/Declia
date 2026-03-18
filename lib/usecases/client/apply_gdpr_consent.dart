import '../../core/utils/clock.dart';
import '../../domain/entities/client.dart';

Client applyGdprConsent(Client client, Clock clock) {
  final prefs = client.communicationPrefs;
  final hasConsent = prefs != null && (prefs.email || prefs.sms || prefs.phone);
  if (hasConsent && client.gdprConsentDate == null) {
    return client.copyWith(gdprConsentDate: clock.now().toUtc());
  }
  return client;
}
