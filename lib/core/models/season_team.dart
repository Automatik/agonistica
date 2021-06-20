import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class SeasonTeam {

  late String id;
  late String teamId;
  late String seasonId;
  late List<String> categoriesIds;
  late List<String> matchesIds;
  late List<String> seasonPlayersIds;

  // temporary, do not store
  Team? team;

  SeasonTeam() {
    id = DbUtils.newUuid();
  }

  SeasonTeam.empty(String teamId, String seasonId) {
    Preconditions.requireArgumentNotEmpty(teamId);
    Preconditions.requireArgumentNotEmpty(seasonId);

    id = DbUtils.newUuid();
    this.teamId = teamId;
    this.seasonId = seasonId;
    categoriesIds = List.empty(growable: true);
    matchesIds = List.empty(growable: true);
    seasonPlayersIds = List.empty(growable: true);
  }

  /// Useful constructor to create both a new Team and a new SeasonTeam
  /// with all the temporary objects populated
  factory SeasonTeam.newTeam(String teamName, String teamImageFilename, String seasonId) {
    Preconditions.requireArgumentNotEmpty(seasonId);

    // New Empty Team
    Team team = Team.name(teamName, teamImageFilename);
    // Create new empty SeasonTeam
    SeasonTeam seasonTeam = SeasonTeam.empty(team.id!, seasonId);
    // Set temporary values
    seasonTeam.team = team;
    return seasonTeam;
  }

  String? getTeamName() {
    _checkTeamTempField();
    return team!.name;
  }

  void addMatch(String matchId) {
    matchesIds = DbUtils.addToListIfAbsent(matchesIds, matchId);
  }

  void addCategory(String categoryId) {
    categoriesIds = DbUtils.addToListIfAbsent(categoriesIds, categoryId);
  }

  void addSeasonPlayer(String seasonPlayerId) {
    seasonPlayersIds = DbUtils.addToListIfAbsent(seasonPlayersIds, seasonPlayerId);
  }

  void removeMatch(String matchId) {
    matchesIds = DbUtils.removeFromList(matchesIds, matchId);
  }

  void removeCategory(String categoryId) {
    categoriesIds = DbUtils.removeFromList(categoriesIds, categoryId);
  }

  void removeSeasonPlayer(String seasonPlayerId) {
    seasonPlayersIds = DbUtils.removeFromList(seasonPlayersIds, seasonPlayerId);
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
      categoriesIds = json['categoriesIds'] == null ? List.empty(growable: true) : List<String>.from(json['categoriesIds']),
      matchesIds = json['matchesIds'] == null ? List.empty(growable: true) : List<String>.from(json['matchesIds']),
      seasonPlayersIds = json['seasonPlayersIds'] == null ? List.empty(growable: true) : List<String>.from(json['seasonPlayersIds']);

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("teamId", teamId);
    Preconditions.requireFieldNotEmpty("seasonId", seasonId);
  }

  void _checkTeamTempField() {
    Preconditions.requireFieldNotNull("team", team);
  }

}