import 'package:declia/core/enums/payment_status.dart';
import 'package:declia/core/enums/session_status.dart';
import 'package:declia/core/enums/session_type.dart';
import 'package:declia/domain/entities/calendar_event.dart';
import 'package:declia/domain/entities/session.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 19);

Session _session() => Session(
  id: 's1',
  tenantId: 'tid',
  clientId: 'cid',
  type: SessionType.portrait,
  status: SessionStatus.scheduled,
  scheduledAt: _now,
  paymentStatus: PaymentStatus.pending,
  amount: 150.0,
  createdAt: _now,
  updatedAt: _now,
);

void main() {
  group('CalendarEvent', () {
    test('clientFullName concatenates first and last name', () {
      final event = CalendarEvent(
        session: _session(),
        clientFirstName: 'Alice',
        clientLastName: 'Dupont',
      );

      expect(event.clientFullName, 'Alice Dupont');
    });

    test('clientFullName handles single-word names', () {
      final event = CalendarEvent(
        session: _session(),
        clientFirstName: 'Alice',
        clientLastName: '',
      );

      expect(event.clientFullName, 'Alice ');
    });

    test('exposes session through session field', () {
      final session = _session();
      final event = CalendarEvent(
        session: session,
        clientFirstName: 'Alice',
        clientLastName: 'Dupont',
      );

      expect(event.session, session);
    });
  });
}
