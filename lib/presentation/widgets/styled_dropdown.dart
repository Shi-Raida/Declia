import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class StyledDropdown<T> extends StatelessWidget {
  const StyledDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
    super.key,
  });

  final T value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButton<T>(
        value: value,
        hint: Text(hint, style: AppTypography.bodySmall()),
        underline: const SizedBox(),
        style: AppTypography.bodySmall().copyWith(color: AppColors.encre),
        items: items,
        onChanged: onChanged,
        isDense: true,
      ),
    );
  }
}
