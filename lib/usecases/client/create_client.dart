import '../../core/errors/failures.dart';
import '../../core/utils/clock.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../usecase.dart';
import 'apply_gdpr_consent.dart';
import 'params.dart';

final class CreateClient extends UseCase<Client, CreateClientParams> {
  const CreateClient(this._clientRepository, this._clock);

  final ClientRepository _clientRepository;
  final Clock _clock;

  @override
  Future<Result<Client, Failure>> call(CreateClientParams params) {
    final now = _clock.now().toUtc();
    final client = applyGdprConsent(
      params.client.copyWith(createdAt: now, updatedAt: now),
      _clock,
    );
    return _clientRepository.create(client);
  }
}
