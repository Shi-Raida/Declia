import '../../core/errors/failures.dart';
import '../../core/storage/local_storage.dart';
import '../../core/utils/result.dart';
import '../usecase.dart';
import 'params.dart';

final class HasExistingConsent extends UseCase<bool, NoParams> {
  const HasExistingConsent(this._localStorage);
  final LocalStorage _localStorage;

  @override
  Future<Result<bool, Failure>> call(NoParams params) async =>
      Ok(_localStorage.read(saveCookieConsentKey) != null);
}
