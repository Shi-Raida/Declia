import 'package:flutter/material.dart';
import 'package:get/get.dart';

mixin ForgotPasswordFormMixin on GetxController {
  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
