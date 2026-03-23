import 'dart:typed_data';

import 'package:declia/core/enums/user_role.dart';
import 'package:declia/core/utils/clock.dart';
import 'package:declia/presentation/services/auth_navigation_service.dart';
import 'package:declia/presentation/services/client_navigation_service.dart';
import 'package:declia/presentation/services/image_picker_service.dart';
import 'package:declia/presentation/services/navigation_service.dart';
import 'package:declia/presentation/services/shell_navigation_service.dart';

final class FakeClock implements Clock {
  FakeClock([DateTime? fixed]) : _now = fixed ?? DateTime(2026, 3, 22);

  final DateTime _now;

  @override
  DateTime now() => _now;
}

final class FakeImagePickerService implements ImagePickerService {
  Uint8List? bytesToReturn;

  @override
  Future<Uint8List?> pickGalleryImage({
    double maxWidth = 300,
    double maxHeight = 300,
    int imageQuality = 70,
  }) async => bytesToReturn;
}

final class FakeNavigationService implements NavigationService {
  String? lastRoute;
  String? lastClientId;
  int goBackCount = 0;

  @override
  String get currentRoute => '';
  @override
  void toLogin({String? reason}) => lastRoute = '/login';
  @override
  void toHome(UserRole role) => lastRoute = '/home';
  @override
  void toDashboard() => lastRoute = '/dashboard';
  @override
  void toAdminPage(String route) => lastRoute = route;
  @override
  void toClientHome() => lastRoute = '/client';
  @override
  void toLegalPrivacy() => lastRoute = '/legal/privacy';
  @override
  void toClientDetail(String id, {dynamic arguments}) => lastClientId = id;
  @override
  void toClientEdit(String id, {dynamic arguments}) => lastClientId = id;
  @override
  void toClientNew() => lastRoute = '/admin/clients/new';
  @override
  void goBack() => goBackCount++;
}

final class FakeAuthNavigationService implements AuthNavigationService {
  String? lastRoute;

  @override
  void toLogin({String? reason}) => lastRoute = '/login';
  @override
  void toHome(UserRole role) => lastRoute = '/home';
}

final class FakeShellNavigationService implements ShellNavigationService {
  String? lastRoute;

  @override
  String get currentRoute => '';
  @override
  void toDashboard() => lastRoute = '/dashboard';
  @override
  void toAdminPage(String route) => lastRoute = route;
  @override
  void toClientHome() => lastRoute = '/client';
  @override
  void toLegalPrivacy() => lastRoute = '/legal/privacy';
}

final class FakeClientNavigationService implements ClientNavigationService {
  String? lastClientId;
  String? lastRoute;
  int goBackCount = 0;

  @override
  void toClientDetail(String id, {dynamic arguments}) => lastClientId = id;
  @override
  void toClientEdit(String id, {dynamic arguments}) => lastClientId = id;
  @override
  void toClientNew() => lastRoute = '/admin/clients/new';
  @override
  void goBack() => goBackCount++;
}
