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

  /// If the list is null, initialize it. If the value provided is not in
  /// the list, add it to the list
  static List<dynamic> addToListIfAbsent(List<dynamic> values, dynamic value) {
    if(values == null) {
      values = [];
    }
    if(!values.contains(value)) {
      values.add(value);
    }
    return values;
  }

  static List<dynamic> removeFromList(List<dynamic> values, dynamic value) {
    if(values == null) {
      return [];
    }
    values.removeWhere((element) => element == value);
    return values;
  }

}