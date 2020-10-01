import 'package:uuid/uuid.dart';

class Category {

  String id;

  String name;

  List<String> matchesIds;
  List<String> playersIds;

  Category() {
    var uuid = Uuid();
    id = uuid.v4();
  }

}