import 'package:flutter/material.dart';

import '../../../core/enums/session_type.dart';
import '../../theme/app_colors.dart';

extension SessionTypeColor on SessionType {
  Color get color => switch (this) {
    SessionType.family => AppColors.terracotta,
    SessionType.equestrian => AppColors.or,
    SessionType.event => AppColors.bleuOuvert,
    SessionType.maternity => const Color(0xFFB07DAD),
    SessionType.school => AppColors.info,
    SessionType.portrait => AppColors.crepuscule,
    SessionType.miniSession => AppColors.success,
    SessionType.other => AppColors.pierre,
  };
}
