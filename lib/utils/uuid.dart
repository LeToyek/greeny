import 'package:uuid/uuid.dart';

class UUIDUtils {
  static String generateUUID() {
    final uuid = const Uuid().v4();
    return uuid;
  }
}
