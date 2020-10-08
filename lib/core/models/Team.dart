import 'package:uuid/uuid.dart';

class Team {

  String id;

  String name;

  List<String> categoriesIds;

  Team() {
    var uuid = Uuid();
    id = uuid.v4();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'categoriesIds': categoriesIds
  };

  Team.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'],
        categoriesIds = json['categoriesIds'] == null ? List() : List<String>.from(json['categoriesIds']);

}