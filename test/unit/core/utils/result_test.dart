import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Ok', () {
    test('fold calls ok callback', () {
      const result = Ok<int, NetworkFailure>(42);
      final out = result.fold(ok: (v) => v * 2, err: (_) => -1);
      expect(out, 84);
    });

    test('isOk is true, isErr is false', () {
      const result = Ok<int, NetworkFailure>(1);
      expect(result.isOk, isTrue);
      expect(result.isErr, isFalse);
    });

    test('map transforms value', () {
      const result = Ok<int, NetworkFailure>(3);
      final mapped = result.map((v) => v.toString());
      expect(mapped, const Ok<String, NetworkFailure>('3'));
    });

    test('mapError is identity for Ok', () {
      const result = Ok<int, NetworkFailure>(5);
      final mapped = result.mapError((_) => const RepositoryFailure('x'));
      expect(mapped, const Ok<int, RepositoryFailure>(5));
    });

    test('getOrElse returns value', () {
      const result = Ok<int, NetworkFailure>(7);
      expect(result.getOrElse((_) => 0), 7);
    });

    test('equality', () {
      expect(
        const Ok<int, NetworkFailure>(1),
        const Ok<int, NetworkFailure>(1),
      );
      expect(
        const Ok<int, NetworkFailure>(1) == const Ok<int, NetworkFailure>(2),
        isFalse,
      );
    });
  });

  group('Err', () {
    test('fold calls err callback', () {
      const result = Err<int, NetworkFailure>(NetworkFailure('fail'));
      final out = result.fold(ok: (v) => v, err: (e) => -1);
      expect(out, -1);
    });

    test('isOk is false, isErr is true', () {
      const result = Err<int, NetworkFailure>(NetworkFailure('fail'));
      expect(result.isOk, isFalse);
      expect(result.isErr, isTrue);
    });

    test('map is identity for Err', () {
      const result = Err<int, NetworkFailure>(NetworkFailure('fail'));
      final mapped = result.map((v) => v.toString());
      expect(mapped, const Err<String, NetworkFailure>(NetworkFailure('fail')));
    });

    test('mapError transforms error', () {
      const result = Err<int, NetworkFailure>(NetworkFailure('fail'));
      final mapped = result.mapError((_) => const RepositoryFailure('wrapped'));
      expect(
        mapped,
        const Err<int, RepositoryFailure>(RepositoryFailure('wrapped')),
      );
    });

    test('getOrElse returns fallback', () {
      const result = Err<int, NetworkFailure>(NetworkFailure('fail'));
      expect(result.getOrElse((_) => 99), 99);
    });

    test('equality', () {
      expect(
        const Err<int, NetworkFailure>(NetworkFailure('a')),
        const Err<int, NetworkFailure>(NetworkFailure('a')),
      );
      expect(
        const Err<int, NetworkFailure>(NetworkFailure('a')) ==
            const Err<int, NetworkFailure>(NetworkFailure('b')),
        isFalse,
      );
    });
  });
}
