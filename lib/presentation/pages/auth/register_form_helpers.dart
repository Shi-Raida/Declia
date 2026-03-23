import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../translations/translation_keys.dart';

/// Shared label widget used across registration step forms.
Widget registerFieldLabel(String text, {bool required = false}) {
  return Row(
    children: [
      Text(
        text.toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: 12.8,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.3,
          color: AppColors.grisTexte,
        ),
      ),
      if (required)
        Text(
          ' *',
          style: GoogleFonts.outfit(
            fontSize: 12.8,
            fontWeight: FontWeight.w600,
            color: AppColors.error,
          ),
        ),
    ],
  );
}

/// Shared text field widget used across registration step forms.
Widget registerTextField({
  required TextEditingController controller,
  required String hint,
  IconData? icon,
  bool required = false,
  TextInputType? keyboard,
  TextInputAction action = TextInputAction.next,
  List<TextInputFormatter>? formatters,
  ValueChanged<String>? onFieldSubmitted,
  FormFieldValidator<String>? validator,
}) {
  return AnimatedSize(
    duration: const Duration(milliseconds: 200),
    curve: Curves.easeOutCubic,
    alignment: Alignment.topCenter,
    child: TextFormField(
      controller: controller,
      keyboardType: keyboard,
      textInputAction: action,
      inputFormatters: formatters,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, size: 18) : null,
      ),
      validator:
          validator ??
          (required
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return Tr.auth.register.fieldRequired.tr;
                  }
                  return null;
                }
              : null),
    ),
  );
}
