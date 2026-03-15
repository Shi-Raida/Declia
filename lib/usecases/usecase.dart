import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';

abstract class UseCase<T, P> {
  const UseCase();
  Future<Result<T, Failure>> call(P params);
}

class NoParams {
  const NoParams();
  @override
  bool operator ==(Object other) => identical(this, other) || other is NoParams;
  @override
  int get hashCode => 0;
}
