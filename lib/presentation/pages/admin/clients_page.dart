import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/acquisition_source.dart';
import '../../controllers/clients_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';
import 'client_table_widget.dart';

class ClientsPage extends GetView<ClientsController> {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: Tr.adminClientsTitle.tr,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ClientsToolbar(controller: controller),
          Expanded(child: _ClientsContent(controller: controller)),
        ],
      ),
    );
  }
}

class _ClientsToolbar extends StatelessWidget {
  const _ClientsToolbar({required this.controller});

  final ClientsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      decoration: const BoxDecoration(
        color: AppColors.bgCard,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 40,
              child: TextField(
                onChanged: (v) => controller.searchQuery.value = v,
                decoration: InputDecoration(
                  hintText: Tr.adminClientsSearch.tr,
                  hintStyle: AppTypography.bodySmall(),
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 18,
                    color: AppColors.pierre,
                  ),
                  filled: true,
                  fillColor: AppColors.bg,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: AppColors.terracotta,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: () => controller.createNewClient(),
            icon: const Icon(Icons.add, size: 18),
            label: Text(Tr.adminClientsNew.tr),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.terracotta,
              foregroundColor: Colors.white,
              textStyle: AppTypography.button(),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              minimumSize: const Size(0, 40),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClientsContent extends StatelessWidget {
  const _ClientsContent({required this.controller});

  final ClientsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.errorMessage.value != null) {
        return Center(
          child: Text(
            controller.errorMessage.value!,
            style: AppTypography.bodyMedium().copyWith(color: AppColors.error),
          ),
        );
      }
      if (controller.clients.isEmpty) {
        return Center(
          child: Text(
            Tr.adminClientsEmpty.tr,
            style: AppTypography.bodyMedium().copyWith(color: AppColors.pierre),
          ),
        );
      }
      return ClientsTable(controller: controller);
    });
  }
}

/// Translates [AcquisitionSource] to its localisation key.
extension AcquisitionSourceTr on AcquisitionSource {
  String get trKey => switch (this) {
    AcquisitionSource.referral => Tr.acquisitionSourceReferral,
    AcquisitionSource.socialMedia => Tr.acquisitionSourceSocialMedia,
    AcquisitionSource.website => Tr.acquisitionSourceWebsite,
    AcquisitionSource.wordOfMouth => Tr.acquisitionSourceWordOfMouth,
    AcquisitionSource.event => Tr.acquisitionSourceEvent,
    AcquisitionSource.other => Tr.acquisitionSourceOther,
  };
}
