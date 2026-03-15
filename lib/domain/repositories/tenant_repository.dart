import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';

import '../entities/tenant.dart';

abstract interface class TenantRepository {
  Future<Result<Tenant, Failure>> fetchCurrentUserTenant();
  Future<Result<Tenant, Failure>> fetchById(String id);
}
