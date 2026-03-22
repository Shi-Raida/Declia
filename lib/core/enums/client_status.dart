import 'package:flutter/material.dart';

import '../../presentation/theme/app_colors.dart';

enum ClientStatus { actif, inactif, nouveau, vip }

extension ClientStatusDisplay on ClientStatus {
  String get label => switch (this) {
    ClientStatus.actif => 'Actif',
    ClientStatus.inactif => 'Inactif',
    ClientStatus.nouveau => 'Nouveau',
    ClientStatus.vip => 'VIP',
  };

  Color get color => switch (this) {
    ClientStatus.actif => AppColors.success,
    ClientStatus.inactif => AppColors.pierre,
    ClientStatus.nouveau => AppColors.bleuOuvert,
    ClientStatus.vip => AppColors.or,
  };
}
