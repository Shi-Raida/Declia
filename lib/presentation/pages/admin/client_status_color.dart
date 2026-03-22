import 'package:flutter/material.dart';

import '../../../core/enums/client_status.dart';
import '../../theme/app_colors.dart';

extension ClientStatusColor on ClientStatus {
  Color get color => switch (this) {
    ClientStatus.actif => AppColors.success,
    ClientStatus.inactif => AppColors.pierre,
    ClientStatus.nouveau => AppColors.bleuOuvert,
    ClientStatus.vip => AppColors.or,
  };
}
