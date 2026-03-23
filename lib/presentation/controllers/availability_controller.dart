import 'package:get/get.dart';

import '../../core/enums/availability_rule_type.dart';
import '../../domain/entities/availability_rule.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/entities/external_calendar_event.dart';
import '../../domain/entities/time_slot.dart';
import '../../domain/services/compute_effective_availability.dart';
import '../../usecases/availability/params.dart';
import '../../usecases/usecase.dart';

final class AvailabilityController extends GetxController {
  AvailabilityController(
    this._fetchAvailabilityRules,
    this._createAvailabilityRule,
    this._updateAvailabilityRule,
    this._deleteAvailabilityRule,
  );

  final UseCase<List<AvailabilityRule>, NoParams> _fetchAvailabilityRules;
  final UseCase<AvailabilityRule, CreateAvailabilityRuleParams>
  _createAvailabilityRule;
  final UseCase<AvailabilityRule, UpdateAvailabilityRuleParams>
  _updateAvailabilityRule;
  final UseCase<void, DeleteAvailabilityRuleParams> _deleteAvailabilityRule;

  final availabilityRules = <AvailabilityRule>[].obs;
  final showAvailability = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadAvailabilityRules();
  }

  Future<void> loadAvailabilityRules() async {
    final result = await _fetchAvailabilityRules(const NoParams());
    result.fold(ok: (list) => availabilityRules.value = list, err: (_) {});
  }

  void toggleAvailability() {
    showAvailability.value = !showAvailability.value;
  }

  List<TimeSlot> availableSlotsForDate(
    DateTime date,
    List<CalendarEvent> events,
    List<ExternalCalendarEvent> externalEvents,
  ) => computeEffectiveAvailability(
    availabilityRules,
    events,
    date,
    externalEvents: externalEvents,
  );

  bool isDateBlocked(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    return availabilityRules.any(
      (r) =>
          r.ruleType == AvailabilityRuleType.blocked &&
          r.specificDate != null &&
          r.specificDate!.year == dateOnly.year &&
          r.specificDate!.month == dateOnly.month &&
          r.specificDate!.day == dateOnly.day,
    );
  }

  bool hasAvailability(
    DateTime date,
    List<CalendarEvent> events,
    List<ExternalCalendarEvent> externalEvents,
  ) => availableSlotsForDate(date, events, externalEvents).isNotEmpty;

  Future<void> createRule(AvailabilityRule rule) async {
    final result = await _createAvailabilityRule((rule: rule));
    result.fold(ok: (_) => loadAvailabilityRules(), err: (_) {});
  }

  Future<void> updateRule(AvailabilityRule rule) async {
    final result = await _updateAvailabilityRule((rule: rule));
    result.fold(ok: (_) => loadAvailabilityRules(), err: (_) {});
  }

  Future<void> deleteRule(String id) async {
    final result = await _deleteAvailabilityRule((id: id));
    result.fold(ok: (_) => loadAvailabilityRules(), err: (_) {});
  }
}
