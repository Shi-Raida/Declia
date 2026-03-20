import 'package:declia/core/utils/uuid_generator.dart';
import 'package:uuid/uuid.dart';

class UuidV4Generator implements UuidGenerator {
  const UuidV4Generator();

  @override
  String generate() => const Uuid().v4();
}
