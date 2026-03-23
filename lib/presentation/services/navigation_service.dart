import 'auth_navigation_service.dart';
import 'client_navigation_service.dart';
import 'shell_navigation_service.dart';

abstract interface class NavigationService
    implements
        AuthNavigationService,
        ShellNavigationService,
        ClientNavigationService {}
