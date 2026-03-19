import 'package:get/get.dart';

import '../../core/enums/calendar_view.dart';
import '../../domain/entities/calendar_event.dart';
import '../../usecases/calendar/params.dart';
import '../../usecases/usecase.dart';
import '../services/navigation_service.dart';

final class PlanningController extends GetxController {
  PlanningController(this._fetchSessions, this._nav);

  final UseCase<List<CalendarEvent>, FetchCalendarSessionsParams> _fetchSessions;
  final NavigationService _nav;

  final currentView = CalendarView.month.obs;
  final focusedDate = DateTime.now().obs;
  final events = <CalendarEvent>[].obs;
  final isLoading = false.obs;
  final errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadSessions();
  }

  Future<void> loadSessions() async {
    isLoading.value = true;
    errorMessage.value = null;
    final range = _computeRange();
    final result = await _fetchSessions((start: range.start, end: range.end));
    result.fold(
      ok: (list) => events.value = list,
      err: (f) => errorMessage.value = f.message,
    );
    isLoading.value = false;
  }

  ({DateTime start, DateTime end}) _computeRange() {
    final d = focusedDate.value;
    switch (currentView.value) {
      case CalendarView.day:
        final start = DateTime(d.year, d.month, d.day);
        return (
          start: start,
          end: DateTime(d.year, d.month, d.day, 23, 59, 59),
        );
      case CalendarView.week:
        final monday = d.subtract(Duration(days: d.weekday - 1));
        final start = DateTime(monday.year, monday.month, monday.day);
        final sunday = start.add(const Duration(days: 6));
        return (
          start: start,
          end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
        );
      case CalendarView.month:
        final first = DateTime(d.year, d.month);
        final start = first.subtract(Duration(days: first.weekday - 1));
        final last = DateTime(d.year, d.month + 1, 0);
        final daysToSunday = last.weekday == 7 ? 0 : 7 - last.weekday;
        final endDay = last.add(Duration(days: daysToSunday));
        return (
          start: start,
          end: DateTime(endDay.year, endDay.month, endDay.day, 23, 59, 59),
        );
    }
  }

  void goToPrevious() {
    final d = focusedDate.value;
    focusedDate.value = switch (currentView.value) {
      CalendarView.day => d.subtract(const Duration(days: 1)),
      CalendarView.week => d.subtract(const Duration(days: 7)),
      CalendarView.month => DateTime(d.year, d.month - 1),
    };
    loadSessions();
  }

  void goToNext() {
    final d = focusedDate.value;
    focusedDate.value = switch (currentView.value) {
      CalendarView.day => d.add(const Duration(days: 1)),
      CalendarView.week => d.add(const Duration(days: 7)),
      CalendarView.month => DateTime(d.year, d.month + 1),
    };
    loadSessions();
  }

  void goToToday() {
    focusedDate.value = DateTime.now();
    loadSessions();
  }

  void setView(CalendarView view) {
    currentView.value = view;
    loadSessions();
  }

  void selectDate(DateTime date) {
    focusedDate.value = date;
    currentView.value = CalendarView.day;
    loadSessions();
  }

  void goToClientProfile(String clientId) => _nav.toClientDetail(clientId);

  String periodLabel() {
    final d = focusedDate.value;
    String pad(int n) => n.toString().padLeft(2, '0');
    switch (currentView.value) {
      case CalendarView.day:
        return '${pad(d.day)}/${pad(d.month)}/${d.year}';
      case CalendarView.week:
        final monday = d.subtract(Duration(days: d.weekday - 1));
        final sunday = monday.add(const Duration(days: 6));
        return '${pad(monday.day)}/${pad(monday.month)} – '
            '${pad(sunday.day)}/${pad(sunday.month)}/${sunday.year}';
      case CalendarView.month:
        return '${pad(d.month)}/${d.year}';
    }
  }

  List<CalendarEvent> eventsForDate(DateTime date) => events
      .where((e) {
        final s = e.session.scheduledAt;
        return s.year == date.year &&
            s.month == date.month &&
            s.day == date.day;
      })
      .toList();
}
