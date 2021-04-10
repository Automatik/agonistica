import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class SeasonTeam {

  String id;
  String teamId;
  String seasonId;
  List<String> categoriesIds;
  List<String> matchesIds;
  List<String> seasonPlayersIds;

  // temporary, do not store
  Team team;

  SeasonTeam() {
    id = DbUtils.newUuid();
  }

  SeasonTeam.empty(String teamId, String seasonId) {
    Preconditions.requireArgumentNotEmpty(teamId);
    Preconditions.requireArgumentNotEmpty(seasonId);

    id = DbUtils.newUuid();
    this.teamId = teamId;
    this.seasonId = seasonId;
    matchesIds = List();
    seasonPlayersIds = List();
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'teamId': teamId,
      'seasonId': seasonId,
      'categoriesIds': categoriesIds,
      'matchesIds': matchesIds,
      'seasonPlayersIds': seasonPlayersIds
    };
  }

  SeasonTeam.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      teamId = json['teamId'],
      seasonId = json['seasonId'],
      categoriesIds = json['categoriesIds'] == null ? List() : List<String>.from(json['categoriesIds']),
      matchesIds = json['matchesIds'] == null ? List() : List<String>.from(json['matchesIds']),
      seasonPlayersIds = json['seasonPlayersIds'] == null ? List() : List<String>.from(json['seasonPlayersIds']);

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("teamId", teamId);
    Preconditions.requireFieldNotEmpty("seasonId", seasonId);
  }

}