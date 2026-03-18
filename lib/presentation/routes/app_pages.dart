import 'package:get/get.dart';

import 'admin_pages.dart';
import 'client_pages.dart';
import 'legal_pages.dart';
import 'shared_pages.dart';

final List<GetPage<dynamic>> appPages = [
  ...sharedPages,
  ...adminPages,
  ...clientPages,
  ...legalPages,
];
