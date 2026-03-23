import 'package:get/get.dart';

import '../../core/errors/failures.dart';
import '../translations/translation_keys.dart';

String translateAuthFailure(Failure failure) {
  if (failure is NetworkFailure) return Tr.auth.error.network.tr;

  final msg = failure.message.toLowerCase();
  if (msg.contains('email') && msg.contains('invalid')) {
    return Tr.auth.error.invalidEmail.tr;
  }
  if (msg.contains('password') && msg.contains('characters')) {
    return Tr.auth.error.passwordTooShort.tr;
  }
  if (msg.contains('rate') ||
      msg.contains('once every') ||
      msg.contains('too many')) {
    return Tr.auth.error.rateLimited.tr;
  }
  return Tr.auth.error.generic.tr;
}
