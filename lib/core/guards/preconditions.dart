import 'package:agonistica/core/exceptions/argument_exception.dart';
import 'package:agonistica/core/exceptions/field_exception.dart';

class Preconditions {

  static void requireArgumentNotNull(String string) {
    if(string == null)
      throw ArgumentException("String argument is null");
  }

  static void requireFieldNotNull(String field, dynamic value) {
    if(value == null) {
      throw FieldException("$field is null");
    }
  }

  static void requireArgumentsNotNulls(List<String> strings) {
    for(String s in strings) {
      if(s == null) {
        throw ArgumentException("One or more elements in the list, passed as argument, is null");
      }
    }
  }

}