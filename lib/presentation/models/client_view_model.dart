import '../../core/enums/acquisition_source.dart';
import '../../domain/entities/client.dart';

class ClientViewModel {
  const ClientViewModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    this.email,
    this.phone,
    this.dateOfBirth,
    this.acquisitionSource,
    required this.tags,
    this.notes,
    this.gdprConsentDate,
    required this.commEmail,
    required this.commSms,
    required this.commPhone,
    this.street,
    this.city,
    this.postalCode,
    this.country,
    this.sessionCount,
    this.totalSpent,
    this.lastShooting,
  });

  factory ClientViewModel.fromEntity(Client c) => ClientViewModel(
    id: c.id,
    firstName: c.firstName,
    lastName: c.lastName,
    createdAt: c.createdAt,
    email: c.email,
    phone: c.phone,
    dateOfBirth: c.dateOfBirth,
    acquisitionSource: c.acquisitionSource,
    tags: c.tags,
    notes: c.notes,
    gdprConsentDate: c.gdprConsentDate,
    commEmail: c.communicationPrefs?.email ?? false,
    commSms: c.communicationPrefs?.sms ?? false,
    commPhone: c.communicationPrefs?.phone ?? false,
    street: c.address?.street,
    city: c.address?.city,
    postalCode: c.address?.postalCode,
    country: c.address?.country,
  );

  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final DateTime? dateOfBirth;
  final AcquisitionSource? acquisitionSource;
  final List<String> tags;
  final String? notes;
  final DateTime? gdprConsentDate;
  final bool commEmail;
  final bool commSms;
  final bool commPhone;
  final String? street;
  final String? city;
  final String? postalCode;
  final String? country;
  final DateTime createdAt;

  // M2-S3 placeholders (populated when Client History lands)
  final int? sessionCount;
  final double? totalSpent;
  final DateTime? lastShooting;

  String get sessionCountDisplay => sessionCount?.toString() ?? '—';
  String get totalSpentDisplay =>
      totalSpent != null ? '${totalSpent!.toStringAsFixed(2)} €' : '—';
  String get lastShootingDisplay => lastShooting != null
      ? '${lastShooting!.day.toString().padLeft(2, '0')}/'
            '${lastShooting!.month.toString().padLeft(2, '0')}/'
            '${lastShooting!.year}'
      : '—';
}
