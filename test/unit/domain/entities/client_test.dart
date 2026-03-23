import 'package:declia/core/enums/acquisition_source.dart';
import 'package:declia/domain/entities/address.dart';
import 'package:declia/domain/entities/client.dart';
import 'package:declia/domain/entities/communication_preferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final createdAt = DateTime(2026, 3, 18, 10, 0, 0);
  final updatedAt = DateTime(2026, 3, 18, 10, 0, 0);

  final fixtureClient = Client(
    id: '00000000-0000-0000-0002-000000000001',
    tenantId: '00000000-0000-0000-0000-000000000001',
    firstName: 'Alice',
    lastName: 'Dupont',
    email: 'alice@test.com',
    phone: '+33612345678',
    company: 'Dupont Photo',
    dateOfBirth: DateTime(1990, 5, 15),
    address: const Address(
      street: '12 rue de la Paix',
      city: 'Paris',
      postalCode: '75001',
      country: 'France',
    ),
    acquisitionSource: AcquisitionSource.socialMedia,
    tags: const ['mariage', 'vip'],
    notes: 'Cliente fidèle',
    communicationPrefs: const CommunicationPreferences(
      email: true,
      sms: false,
      phone: true,
    ),
    gdprConsentDate: DateTime(2026, 1, 1),
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  group('Client', () {
    test('toJson / fromJson round-trip preserves all fields', () {
      final json = fixtureClient.toJson();
      final restored = Client.fromJson(json);

      expect(restored.id, fixtureClient.id);
      expect(restored.tenantId, fixtureClient.tenantId);
      expect(restored.firstName, fixtureClient.firstName);
      expect(restored.lastName, fixtureClient.lastName);
      expect(restored.email, fixtureClient.email);
      expect(restored.phone, fixtureClient.phone);
      expect(restored.company, fixtureClient.company);
      expect(restored.acquisitionSource, fixtureClient.acquisitionSource);
      expect(restored.tags, fixtureClient.tags);
      expect(restored.notes, fixtureClient.notes);
      expect(
        restored.communicationPrefs?.email,
        fixtureClient.communicationPrefs?.email,
      );
      expect(
        restored.communicationPrefs?.sms,
        fixtureClient.communicationPrefs?.sms,
      );
      expect(
        restored.communicationPrefs?.phone,
        fixtureClient.communicationPrefs?.phone,
      );
    });

    test('AcquisitionSource serializes to snake_case JSON values', () {
      expect(
        AcquisitionSource.socialMedia.name,
        'socialMedia',
        reason: 'Dart enum name is camelCase',
      );

      final json = fixtureClient.toJson();
      expect(
        json['acquisition_source'],
        'social_media',
        reason: '@JsonValue annotation maps to snake_case',
      );
    });

    test('fromJson reads snake_case acquisition_source correctly', () {
      final json = fixtureClient.toJson();
      json['acquisition_source'] = 'word_of_mouth';
      final client = Client.fromJson(json);
      expect(client.acquisitionSource, AcquisitionSource.wordOfMouth);
    });

    test('fromJson handles null optional fields', () {
      final json = fixtureClient.toJson();
      json['email'] = null;
      json['phone'] = null;
      json['acquisition_source'] = null;
      json['gdpr_consent_date'] = null;

      final client = Client.fromJson(json);
      expect(client.email, isNull);
      expect(client.phone, isNull);
      expect(client.acquisitionSource, isNull);
      expect(client.gdprConsentDate, isNull);
    });

    test('tags default to empty list when not provided', () {
      final minimal = Client(
        id: 'id',
        tenantId: 'tid',
        firstName: 'Bob',
        lastName: 'Martin',
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
      expect(minimal.tags, isEmpty);
    });

    test('CommunicationPreferences defaults to all false', () {
      const prefs = CommunicationPreferences();
      expect(prefs.email, isFalse);
      expect(prefs.sms, isFalse);
      expect(prefs.phone, isFalse);
    });

    test('Address round-trip preserves postalCode with JsonKey', () {
      const address = Address(
        street: '10 rue test',
        city: 'Lyon',
        postalCode: '69001',
        country: 'France',
      );
      final json = address.toJson();
      expect(json['postal_code'], '69001');
      final restored = Address.fromJson(json);
      expect(restored.postalCode, '69001');
    });
  });
}
