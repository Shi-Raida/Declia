import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class SettingsAuthCodeInput extends StatefulWidget {
  const SettingsAuthCodeInput({
    required this.authUrl,
    required this.onSubmit,
    required this.onCancel,
    super.key,
  });

  final String authUrl;
  final Future<void> Function(String code) onSubmit;
  final VoidCallback onCancel;

  @override
  State<SettingsAuthCodeInput> createState() => _SettingsAuthCodeInputState();
}

class _SettingsAuthCodeInputState extends State<SettingsAuthCodeInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.orLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.or.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Tr.admin.settings.googleCalendar.authCode.tr,
            style: AppTypography.bodyMedium().copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          // URL to open manually
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.authUrl,
                  style: AppTypography.bodySmall().copyWith(
                    color: AppColors.bleuOuvert,
                    decoration: TextDecoration.underline,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy, size: 16),
                onPressed: () =>
                    Clipboard.setData(ClipboardData(text: widget.authUrl)),
                tooltip: 'Copy URL',
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: Tr.admin.settings.googleCalendar.authCodeHint.tr,
              border: const OutlineInputBorder(),
            ),
            style: AppTypography.bodySmall(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              FilledButton(
                onPressed: () => widget.onSubmit(_controller.text),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.terracotta,
                  foregroundColor: Colors.white,
                  textStyle: AppTypography.button(),
                ),
                child: Text(Tr.admin.settings.googleCalendar.connect.tr),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: widget.onCancel,
                child: Text(
                  Tr.admin.clientForm.cancel.tr,
                  style: AppTypography.button().copyWith(
                    color: AppColors.pierre,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
