import 'package:flutter/material.dart';

import '../../../core/enums/session_type.dart';
import '../../theme/app_colors.dart';

extension SessionTypeColor on SessionType {
  Color get color => switch (this) {
    SessionType.family => AppColors.bleuOuvert,
    SessionType.equestrian => AppColors.equestrian,
    SessionType.event => AppColors.bleuOuvert,
    SessionType.maternity => AppColors.grossesse,
    SessionType.school => AppColors.info,
    SessionType.portrait => AppColors.or,
    SessionType.miniSession => AppColors.success,
    SessionType.other => AppColors.pierre,
  };
}
