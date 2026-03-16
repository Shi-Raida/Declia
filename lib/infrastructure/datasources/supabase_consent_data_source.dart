import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_exception.dart';
import 'contract/consent_data_source.dart';

final class SupabaseConsentDataSource implements ConsentDataSource {
  const SupabaseConsentDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<void> saveConsent({
    required String consentType,
    required bool granted,
    required String anonId,
  }) async {
    try {
      await _client.from('consent_records').insert({
        'anon_id': anonId,
        'consent_type': consentType,
        'granted': granted,
      });
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }
}
