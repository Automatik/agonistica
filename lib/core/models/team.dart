import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class Team {

  String id;

  String name;

  List<String> categoriesIds;

  List<String> matchesIds;
  List<String> playersIds;

  Team() {
    id = DbUtils.newUuid();
  }

  Team.name(String name) {
    id = DbUtils.newUuid();
    this.name = name;
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'name': name,
      'categoriesIds': categoriesIds,
      'matchesIds': matchesIds,
      'playersIds': playersIds
    };
  }

  Team.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'],
        categoriesIds = json['categoriesIds'] == null ? List() : List<String>.from(json['categoriesIds']),
        matchesIds = json['matchesIds'] == null ? List() : List<String>.from(json['matchesIds']),
        playersIds = json['playersIds'] == null ? List() : List<String>.from(json['playersIds']);

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("name", name);
  }

}