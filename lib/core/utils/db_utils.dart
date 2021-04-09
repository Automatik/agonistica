import 'package:uuid/uuid.dart';

class DbUtils {

  static String newUuid() {
    var uuid = Uuid();
    return uuid.v4();
  }

  /// Remove null values from a list. Helpful to avoid exceptions when passing
  /// for instance a list of ids of objects to retrieve, but some of them are
  /// null
  static List<dynamic> removeNullValues(List<dynamic> values) {
    List<dynamic> validValues = List.from(values);
    validValues.retainWhere((element) => element != null);
    return validValues;
  }

  static bool listContainsNulls(List<dynamic> values) {
    return values.any((element) => element == null);
  }

}