import 'package:uuid/uuid.dart';

class Utils {
  static String generateUid(){
    var uuid = const Uuid();
    return uuid.v4();
  }
}