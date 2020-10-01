import 'package:uuid/uuid.dart';

class Team {

  String id;

  String name;

  List<String> categoriesIds;

  Team() {
    var uuid = Uuid();
    id = uuid.v4();
  }

}