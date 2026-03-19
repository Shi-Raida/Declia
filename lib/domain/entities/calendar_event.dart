import 'session.dart';

class CalendarEvent {
  const CalendarEvent({
    required this.session,
    required this.clientFirstName,
    required this.clientLastName,
  });

  final Session session;
  final String clientFirstName;
  final String clientLastName;

  String get clientFullName => '$clientFirstName $clientLastName';
}
