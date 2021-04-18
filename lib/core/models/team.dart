import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class Team {

  String id;

  String name;

  List<String> seasonTeamsIds;

  Team() {
    id = DbUtils.newUuid();
  }

  Team.name(String name) {
    id = DbUtils.newUuid();
    this.name = name;
    seasonTeamsIds = List();
  }

  Team.nameWithNoId(String name) {
    id = null;
    this.name = name;
    seasonTeamsIds = List();
  }

  void addSeasonTeam(String seasonTeamId) {
    seasonTeamsIds = DbUtils.addToListIfAbsent(seasonTeamsIds, seasonTeamId);
  }

  void removeSeasonTeam(String seasonTeamId) {
    seasonTeamsIds = DbUtils.removeFromList(seasonTeamsIds, seasonTeamId);
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'name': name,
      'seasonTeamsIds': seasonTeamsIds
    };
  }

  Team.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'],
        seasonTeamsIds = json['seasonTeamsIds'] == null ? List(): List<String>.from(json['seasonTeamsIds']);

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("name", name);
  }

}