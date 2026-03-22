import 'package:flutter/services.dart';

/// Formats phone input as `06 12 34 56 78` (groups of 2, max 10 digits).
class FrenchPhoneFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 10 ? digits.substring(0, 10) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < limited.length; i++) {
      if (i > 0 && i.isEven) buffer.write(' ');
      buffer.write(limited[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formats postal code as `XX XXX` (space after 2nd digit, max 5 digits).
class PostalCodeFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 5 ? digits.substring(0, 5) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < limited.length; i++) {
      if (i == 2) buffer.write(' ');
      buffer.write(limited[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formats French VAT number as `FRXX XXX XXX XXX` (groups 4-3-3-3, max 13 alphanumeric).
class VatNumberFormatter extends TextInputFormatter {
  static const _groupSizes = [4, 3, 3, 3];

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final alphanumeric = newValue.text
        .replaceAll(RegExp(r'[^A-Za-z0-9]'), '')
        .toUpperCase();
    final limited = alphanumeric.length > 13
        ? alphanumeric.substring(0, 13)
        : alphanumeric;
    final buffer = StringBuffer();
    var pos = 0;
    for (var g = 0; g < _groupSizes.length && pos < limited.length; g++) {
      if (g > 0) buffer.write(' ');
      final end = (pos + _groupSizes[g]).clamp(0, limited.length);
      buffer.write(limited.substring(pos, end));
      pos = end;
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

/// Formats SIRET as `XXX XXX XXX XXXXX` (groups 3-3-3-5, max 14 digits).
class SiretFormatter extends TextInputFormatter {
  static const _groupSizes = [3, 3, 3, 5];

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 14 ? digits.substring(0, 14) : digits;
    final buffer = StringBuffer();
    var pos = 0;
    for (var g = 0; g < _groupSizes.length && pos < limited.length; g++) {
      if (g > 0) buffer.write(' ');
      final end = (pos + _groupSizes[g]).clamp(0, limited.length);
      buffer.write(limited.substring(pos, end));
      pos = end;
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
