import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/client_list_query.dart';
import '../../controllers/clients_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class ClientsTagFilterRow extends StatelessWidget {
  const ClientsTagFilterRow({
    required this.controller,
    required this.query,
    super.key,
  });

  final ClientsController controller;
  final ClientListQuery query;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          '${Tr.adminClientsFilterByTag.tr}: ',
          style: AppTypography.bodySmall().copyWith(color: AppColors.pierre),
        ),
        SizedBox(
          width: 160,
          height: 32,
          child: Autocomplete<String>(
            optionsBuilder: (textEditingValue) {
              final input = textEditingValue.text.toLowerCase();
              if (input.isEmpty) return const [];
              return controller.availableTags.where(
                (tag) =>
                    tag.toLowerCase().contains(input) &&
                    !query.tags.contains(tag),
              );
            },
            onSelected: (tag) => controller.addTag(tag),
            fieldViewBuilder:
                (context, textController, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: textController,
                    focusNode: focusNode,
                    style: AppTypography.bodySmall(),
                    decoration: InputDecoration(
                      hintText: Tr.adminClientsFilterTagHint.tr,
                      hintStyle: AppTypography.bodySmall(),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: const BorderSide(
                          color: AppColors.terracotta,
                        ),
                      ),
                    ),
                    onSubmitted: (value) {
                      final tag = value.trim();
                      if (tag.isNotEmpty) {
                        controller.addTag(tag);
                        textController.clear();
                      }
                    },
                  );
                },
          ),
        ),
        const SizedBox(width: 4),
        ...query.tags.map(
          (tag) => Padding(
            padding: const EdgeInsets.only(right: 4),
            child: InputChip(
              label: Text(tag, style: AppTypography.bodySmall()),
              onDeleted: () => controller.removeTag(tag),
              backgroundColor: AppColors.terracottaLight,
              deleteIconColor: AppColors.pierre,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ),
      ],
    );
  }
}
