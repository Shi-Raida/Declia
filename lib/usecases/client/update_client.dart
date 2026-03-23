import '../../core/errors/failures.dart';
import '../../core/utils/clock.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../usecase.dart';
import 'apply_gdpr_consent.dart';
import 'params.dart';

final class UpdateClient extends UseCase<Client, UpdateClientParams> {
  const UpdateClient(this._clientRepository, this._clock);

  final ClientWriter _clientRepository;
  final Clock _clock;

  @override
  Future<Result<Client, Failure>> call(UpdateClientParams params) {
    final client = applyGdprConsent(
      params.client.copyWith(updatedAt: _clock.now().toUtc()),
      _clock,
    );
    return _clientRepository.update(client);
  }
}
