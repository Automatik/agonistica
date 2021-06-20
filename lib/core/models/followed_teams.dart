import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class FollowedTeams {

  late String id;

  late List<String> teamsIds;

  FollowedTeams() {
    id = DbUtils.newUuid();
  }

  FollowedTeams.empty() {
    id = DbUtils.newUuid();
    teamsIds = List.empty(growable: true);
  }

  void addTeam(String teamId) {
    teamsIds = DbUtils.addToListIfAbsent(teamsIds, teamId);
  }

  void removeTeam(String teamId) {
    teamsIds = DbUtils.removeFromList(teamsIds, teamId);
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'teamsIds': teamsIds
    };
  }

  FollowedTeams.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      teamsIds = json['teamsIds'] == null ? List.empty(growable: true) : List<String>.from(json['teamsIds']);

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
  }

}