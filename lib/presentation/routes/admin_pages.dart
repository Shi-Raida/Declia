import 'package:get/get.dart';

import '../../core/enums/user_role.dart';
import '../controllers/auth_state_controller.dart';
import '../middleware/auth_middleware.dart';
import '../middleware/role_middleware.dart';
import '../pages/admin/admin_shell_binding.dart';
import '../pages/admin/client_detail_binding.dart';
import '../pages/admin/client_detail_page.dart';
import '../pages/admin/client_form_binding.dart';
import '../pages/admin/client_form_page.dart';
import '../pages/admin/clients_binding.dart';
import '../pages/admin/clients_page.dart';
import '../pages/admin/dashboard_binding.dart';
import '../pages/admin/dashboard_page.dart';
import '../pages/admin/galleries_page.dart';
import '../pages/admin/invoicing_page.dart';
import '../pages/admin/planning_binding.dart';
import '../pages/admin/planning_page.dart';
import '../pages/admin/settings_binding.dart';
import '../pages/admin/settings_page.dart';
import '../pages/admin/gift_cards_page.dart';
import '../pages/admin/orders_page.dart';
import '../pages/admin/promotions_page.dart';
import '../pages/admin/shop_page.dart';
import '../pages/admin/statistics_page.dart';
import '../pages/admin/tasks_page.dart';
import 'app_routes.dart';

List<GetMiddleware> _adminMiddlewares() => [
  AuthMiddleware(Get.find<AuthStateController>()),
  RoleMiddleware(Get.find<AuthStateController>(), {
    UserRole.photographer,
    UserRole.tech,
  }),
];

final List<GetPage<dynamic>> adminPages = [
  GetPage<void>(
    name: AppRoutes.adminDashboard,
    page: () => const DashboardPage(),
    binding: BindingsBuilder(() {
      AdminShellBinding().dependencies();
      DashboardBinding().dependencies();
    }),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminClients,
    page: () => const ClientsPage(),
    binding: BindingsBuilder(() {
      AdminShellBinding().dependencies();
      ClientsBinding().dependencies();
    }),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminClientNew,
    page: () => const ClientFormPage(),
    binding: BindingsBuilder(() {
      AdminShellBinding().dependencies();
      ClientFormBinding().dependencies();
    }),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminClientDetail,
    page: () => const ClientDetailPage(),
    binding: BindingsBuilder(() {
      AdminShellBinding().dependencies();
      ClientDetailBinding().dependencies();
    }),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminClientEdit,
    page: () => const ClientFormPage(),
    binding: BindingsBuilder(() {
      AdminShellBinding().dependencies();
      ClientFormBinding().dependencies();
    }),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminPlanning,
    page: () => const PlanningPage(),
    binding: BindingsBuilder(() {
      AdminShellBinding().dependencies();
      PlanningBinding().dependencies();
    }),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminGalleries,
    page: () => const GalleriesPage(),
    binding: AdminShellBinding(),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminShop,
    page: () => const ShopPage(),
    binding: AdminShellBinding(),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminInvoicing,
    page: () => const InvoicingPage(),
    binding: AdminShellBinding(),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminStatistics,
    page: () => const StatisticsPage(),
    binding: AdminShellBinding(),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminSettings,
    page: () => const SettingsPage(),
    binding: BindingsBuilder(() {
      AdminShellBinding().dependencies();
      SettingsBinding().dependencies();
    }),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminOrders,
    page: () => const OrdersPage(),
    binding: AdminShellBinding(),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminGiftCards,
    page: () => const GiftCardsPage(),
    binding: AdminShellBinding(),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminPromotions,
    page: () => const PromotionsPage(),
    binding: AdminShellBinding(),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
  GetPage<void>(
    name: AppRoutes.adminTasks,
    page: () => const TasksPage(),
    binding: AdminShellBinding(),
    middlewares: _adminMiddlewares(),
    transition: Transition.noTransition,
  ),
];
