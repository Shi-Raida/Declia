import 'package:get/get.dart';

import '../../core/errors/failures.dart';
import '../translations/translation_keys.dart';

String translateAuthFailure(Failure failure) {
  if (failure is NetworkFailure) return Tr.authErrorNetwork.tr;

  final msg = failure.message.toLowerCase();
  if (msg.contains('email') && msg.contains('invalid')) {
    return Tr.authErrorInvalidEmail.tr;
  }
  if (msg.contains('password') && msg.contains('characters')) {
    return Tr.authErrorPasswordTooShort.tr;
  }
  if (msg.contains('rate') ||
      msg.contains('once every') ||
      msg.contains('too many')) {
    return Tr.authErrorRateLimited.tr;
  }
  return Tr.authErrorGeneric.tr;
}
