import 'keys/tr_admin.dart';
import 'keys/tr_auth.dart';
import 'keys/tr_common.dart';

export 'keys/tr_admin.dart';
export 'keys/tr_auth.dart';
export 'keys/tr_common.dart';

abstract final class Tr {
  static const admin = TrAdminScope();
  static const auth = TrAuthScope();
  static const common = TrCommonScope();
}
