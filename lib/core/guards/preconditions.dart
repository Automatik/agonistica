import 'package:agonistica/core/exceptions/argument_exception.dart';

class Preconditions {

  static void requireNotNull(String string) {
    if(string == null)
      throw ArgumentException("String argument is null");
  }

  static void requireNotNulls(List<String> strings) {
    for(String s in strings) {
      if(s == null) {
        throw ArgumentException("One or more elements in the list, passed as argument, is null");
      }
    }
  }

}