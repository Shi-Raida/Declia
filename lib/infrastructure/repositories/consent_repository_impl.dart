import '../../core/enums/consent_type.dart';
import '../../core/errors/failures.dart';
import '../../core/repositories/repository_guard.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/consent_repository.dart';
import '../datasources/contract/consent_data_source.dart';

final class ConsentRepositoryImpl implements ConsentRepository {
  const ConsentRepositoryImpl({
    required ConsentDataSource dataSource,
    required RepositoryGuard guard,
  }) : _dataSource = dataSource,
       _guard = guard;

  final ConsentDataSource _dataSource;
  final RepositoryGuard _guard;

  @override
  Future<Result<void, Failure>> saveConsent({
    required ConsentType consentType,
    required bool granted,
    required String anonId,
  }) => _guard(
    () => _dataSource.saveConsent(
      consentType: consentType.name,
      granted: granted,
      anonId: anonId,
    ),
    method: 'saveConsent',
  );
}
