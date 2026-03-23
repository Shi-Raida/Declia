import '../translations/translation_keys.dart';

/// Validates a French VAT number (TVA intracommunautaire).
///
/// Format: `FR` + 2-digit key + 9-digit SIREN (13 chars total, spaces ignored).
/// Returns the translation key on failure, `null` if valid or empty.
String? validateFrenchVat(String? value) {
  if (value == null || value.trim().isEmpty) return null;

  final raw = value.replaceAll(' ', '').toUpperCase();

  if (raw.length != 13) return Tr.registerVatInvalid;
  if (!raw.startsWith('FR')) return Tr.registerVatInvalid;

  final keyPart = raw.substring(2, 4);
  final sirenPart = raw.substring(4);

  final key = int.tryParse(keyPart);
  final siren = int.tryParse(sirenPart);

  if (key == null || siren == null) return Tr.registerVatInvalid;

  final expected = (12 + 3 * (siren % 97)) % 97;
  if (key != expected) return Tr.registerVatInvalid;

  return null;
}
