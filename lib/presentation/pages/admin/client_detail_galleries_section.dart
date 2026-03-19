import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/gallery.dart';
import 'history_enum_extensions.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class ClientDetailGalleriesSection extends StatelessWidget {
  const ClientDetailGalleriesSection({super.key, required this.galleries});

  final List<Gallery> galleries;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            Tr.adminHistoryGalleries.tr.toUpperCase(),
            style: AppTypography.label(),
          ),
          const SizedBox(height: 12),
          if (galleries.isEmpty)
            Text(
              Tr.adminHistoryGalleriesEmpty.tr,
              style: AppTypography.bodyMedium().copyWith(
                color: AppColors.pierre,
              ),
            )
          else
            ...galleries.map((g) => _GalleryRow(gallery: g)),
        ],
      ),
    );
  }
}

class _GalleryRow extends StatelessWidget {
  const _GalleryRow({required this.gallery});

  final Gallery gallery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(gallery.title, style: AppTypography.bodyMedium()),
          ),
          const SizedBox(width: 12),
          Text(
            gallery.status.trKey.tr,
            style: AppTypography.bodySmall().copyWith(color: AppColors.pierre),
          ),
          const SizedBox(width: 12),
          Text(
            '${gallery.photoCount} ${Tr.adminHistoryPhotos.tr}',
            style: AppTypography.bodySmall().copyWith(color: AppColors.pierre),
          ),
        ],
      ),
    );
  }
}
