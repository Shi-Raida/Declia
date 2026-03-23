import 'package:declia/presentation/translations/translation_keys.dart';
import 'package:declia/presentation/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validateFrenchVat', () {
    test('returns null for null input (optional field)', () {
      expect(validateFrenchVat(null), isNull);
    });

    test('returns null for empty string (optional field)', () {
      expect(validateFrenchVat(''), isNull);
      expect(validateFrenchVat('   '), isNull);
    });

    test('returns null for valid VAT with spaces', () {
      // SIREN 123456789 → key = (12 + 3*(123456789 % 97)) % 97
      // 123456789 % 97 = 123456789 - 1272750*97 = 123456789 - 123456750 = 39
      // key = (12 + 3*39) % 97 = (12 + 117) % 97 = 129 % 97 = 32
      expect(validateFrenchVat('FR32 123 456 789'), isNull);
    });

    test('returns null for valid VAT without spaces', () {
      expect(validateFrenchVat('FR32123456789'), isNull);
    });

    test('returns null for valid VAT lowercase', () {
      expect(validateFrenchVat('fr32123456789'), isNull);
    });

    test('returns error for wrong prefix', () {
      expect(validateFrenchVat('DE32123456789'), Tr.registerVatInvalid);
    });

    test('returns error for wrong length', () {
      expect(validateFrenchVat('FR3212345678'), Tr.registerVatInvalid);
      expect(validateFrenchVat('FR321234567890'), Tr.registerVatInvalid);
    });

    test('returns error for bad check digit', () {
      // key 33 instead of 32
      expect(validateFrenchVat('FR33123456789'), Tr.registerVatInvalid);
    });

    test('returns error for non-numeric key', () {
      expect(validateFrenchVat('FRAA123456789'), Tr.registerVatInvalid);
    });

    test('returns error for non-numeric SIREN', () {
      expect(validateFrenchVat('FR32ABCDEFGHI'), Tr.registerVatInvalid);
    });
  });
}
