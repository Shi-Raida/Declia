import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class UpdateClient extends UseCase<Client, UpdateClientParams> {
  const UpdateClient(this._clientRepository);

  final ClientRepository _clientRepository;

  @override
  Future<Result<Client, Failure>> call(UpdateClientParams params) {
    final client = params.client;
    // Auto-set gdprConsentDate when any communication preference is enabled
    final prefs = client.communicationPrefs;
    final hasConsent =
        prefs != null && (prefs.email || prefs.sms || prefs.phone);
    final clientToUpdate = hasConsent && client.gdprConsentDate == null
        ? client.copyWith(gdprConsentDate: DateTime.now().toUtc())
        : client;
    return _clientRepository.update(clientToUpdate);
  }
}
