import '../../../domain/entities/availability_rule.dart';

abstract interface class AvailabilityDataSource {
  Future<List<AvailabilityRule>> fetchAll();
  Future<AvailabilityRule> create(AvailabilityRule rule);
  Future<AvailabilityRule> update(AvailabilityRule rule);
  Future<void> delete(String id);
}
