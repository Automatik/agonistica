import 'package:uuid/uuid.dart';

class Team {

  String id;

  String name;

  List<String> categoriesIds;

  List<String> matchesIds;
  List<String> playersIds;

  Team() {
    var uuid = Uuid();
    id = uuid.v4();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'categoriesIds': categoriesIds,
    'matchesIds' : matchesIds,
    'playersIds' : playersIds
  };

  Team.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'],
        categoriesIds = json['categoriesIds'] == null ? List() : List<String>.from(json['categoriesIds']),
        matchesIds = json['matchesIds'] == null ? List() : List<String>.from(json['matchesIds']),
        playersIds = json['playersIds'] == null ? List() : List<String>.from(json['playersIds']);
}