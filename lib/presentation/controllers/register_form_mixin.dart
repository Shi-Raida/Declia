import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_form_mixin.dart';

mixin RegisterFormMixin on GetxController, LoginFormMixin {
  final confirmPasswordController = TextEditingController();

  @override
  void onClose() {
    confirmPasswordController.dispose();
    super.onClose();
  }
}
