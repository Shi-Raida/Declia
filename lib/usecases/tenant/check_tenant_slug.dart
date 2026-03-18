import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class CheckTenantSlug extends UseCase<bool, CheckTenantSlugParams> {
  const CheckTenantSlug(this._tenantRepository);

  final TenantRepository _tenantRepository;

  @override
  Future<Result<bool, Failure>> call(CheckTenantSlugParams params) =>
      _tenantRepository.existsBySlug(params.slug);
}
