import 'package:agonistica/core/exceptions/argument_exception.dart';
import 'package:agonistica/core/exceptions/field_exception.dart';

class Preconditions {

  static void requireArgumentNotNull(String string) {
    if(string == null)
      throw ArgumentException("String argument is null");
  }

  static void requireArgumentGreaterThanZero(int value) {
    if(value <= 0) {
      throw ArgumentException("Int argument is less or equal than zero");
    }
  }

  static void requireArgumentGreaterThan(int value, int compare) {
    if(value <= compare) {
      throw ArgumentException("Int argument is less or equal than other argument with value $compare");
    }
  }

  static void requireFieldNotNull(String field, dynamic value) {
    if(value == null) {
      throw FieldException("The field $field is null");
    }
  }

  static void requireFieldGreaterThanZero(String field, int value) {
    if(value <= 0) {
      throw FieldException("The field $field is less or equal than zero");
    }
  }

  static void requireFieldGreaterThan(String field, int value, int compare) {
    if(value <= compare) {
      throw FieldException("The field $field is less or equal than other argument with value $compare");
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