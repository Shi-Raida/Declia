abstract interface class ConsentDataSource {
  Future<void> saveConsent({
    required String consentType,
    required bool granted,
    required String anonId,
  });
}
