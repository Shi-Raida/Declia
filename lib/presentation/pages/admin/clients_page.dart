import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/clients_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';
import '../../widgets/admin/stat_card.dart';
import 'client_table_widget.dart';
import 'clients_filter_bar.dart';
import 'clients_pagination_bar.dart';

class ClientsPage extends GetView<ClientsController> {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: Tr.adminClientsTitle.tr,
      topbarActions: [
        OutlinedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.download_outlined, size: 18),
          label: Text(Tr.adminClientsExport.tr),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.pierre,
            side: const BorderSide(color: AppColors.border),
            textStyle: AppTypography.button(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            minimumSize: const Size(0, 40),
          ),
        ),
        const SizedBox(width: 8),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Stats row
          Obx(
            () => Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                children: [
                  Expanded(
                    child: StatCard(
                      icon: Icons.people_outline,
                      iconColor: AppColors.bleuOuvert,
                      label: Tr.adminClientsTotalClients.tr,
                      value: '${controller.totalCount.value}',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.check_circle_outline,
                      iconColor: AppColors.success,
                      label: Tr.adminClientsActive.tr,
                      value: '—',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.person_add_outlined,
                      iconColor: AppColors.or,
                      label: Tr.adminClientsStatNew.tr,
                      value: '—',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      icon: Icons.euro_outlined,
                      iconColor: AppColors.terracotta,
                      label: Tr.adminClientsAvgRevenue.tr,
                      value: '—',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ClientsFilterBar(controller: controller),
          Expanded(child: _ClientsContent(controller: controller)),
          ClientsPaginationBar(controller: controller),
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
