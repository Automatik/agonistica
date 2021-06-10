

import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class FollowedTeams {

  late String id;

  List<String?>? teamsIds;

  FollowedTeams() {
    id = DbUtils.newUuid();
  }

  FollowedTeams.empty() {
    id = DbUtils.newUuid();
    teamsIds = List.empty();
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
      teamsIds = json['teamsIds'] == null ? List.empty() : List<String>.from(json['teamsIds']);

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
  }

}