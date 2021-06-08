// @dart=2.9

import 'package:agonistica/core/exceptions/argument_exception.dart';
import 'package:agonistica/core/exceptions/field_exception.dart';

class Preconditions {

  static void requireArgumentStringNotNull(String string) {
    if(string == null)
      throw ArgumentException("String argument is null");
  }

  static void requireArgumentNotNull(dynamic value) {
    if(value == null)
      throw ArgumentException("Argument is null");
  }

  static void requireArgumentNotEmpty(String string) {
    requireArgumentStringNotNull(string);
    if(string.isEmpty)
      throw ArgumentException("String argument is null");
  }

  static void requireArgumentGreaterThanZero(int value) {
    if(value <= 0) {
      throw ArgumentException("Int argument is less or equal than zero");
    }
  }

  static void requireArgumentLessThan(int value, int compare) {
    if(value >= compare) {
      throw ArgumentException("Int argument is greater or equal than other argument with value $compare");
    }
  }

  static void requireArgumentGreaterThan(int value, int compare) {
    if(value <= compare) {
      throw ArgumentException("Int argument is less or equal than other argument with value $compare");
    }
  }

  static void requireArgumentsNotNulls(List<String> strings) {
    for(String s in strings) {
      if(s == null) {
        throw ArgumentException("One or more elements in the list, passed as argument, is null");
      }
    }
  }

  static void requireFieldNotNull(String field, dynamic value) {
    if(value == null) {
      throw FieldException("The field $field is null");
    }
  }

  static void requireFieldNotEmpty(String field, String value) {
    requireFieldNotNull(field, value);
    if(value.isEmpty) {
      throw FieldException("The field $field is empty");
    }
  }

  static void requireFieldsNotNulls(String field, List<String> strings) {
    for(String s in strings) {
      if(s == null) {
        throw FieldException("One or more elements in the list of the field $field is null");
      }
    }
  }

  static void requireFieldGreaterThanZero(String field, int value) {
    if(value <= 0) {
      throw FieldException("The field $field is less or equal than zero");
    }
  }

  static void requireFieldLessThan(String field, int value, int compare) {
    if(value >= compare) {
      throw FieldException("The field $field is greater or equal than other argument with value $compare");
    }
  }

  static void requireFieldGreaterThan(String field, int value, int compare) {
    if(value <= compare) {
      throw FieldException("The field $field is less or equal than other argument with value $compare");
    }
  }

}