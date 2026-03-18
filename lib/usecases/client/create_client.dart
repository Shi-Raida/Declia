import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class CreateClient extends UseCase<Client, CreateClientParams> {
  const CreateClient(this._clientRepository);

  final ClientRepository _clientRepository;

  @override
  Future<Result<Client, Failure>> call(CreateClientParams params) {
    final client = params.client;
    // Auto-set gdprConsentDate when any communication preference is enabled
    final prefs = client.communicationPrefs;
    final hasConsent =
        prefs != null && (prefs.email || prefs.sms || prefs.phone);
    final clientToCreate = hasConsent && client.gdprConsentDate == null
        ? client.copyWith(gdprConsentDate: DateTime.now().toUtc())
        : client;
    return _clientRepository.create(clientToCreate);
  }
}
