abstract class UseCase<T, P> {
  const UseCase();
  Future<T> call(P params);
}

class NoParams {
  const NoParams();
  @override
  bool operator ==(Object other) => identical(this, other) || other is NoParams;
  @override
  int get hashCode => 0;
}
