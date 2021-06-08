// @dart=2.9

import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/models/match_player_data.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/utils/my_date_utils.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class Match {

  String id;

  String categoryId;

  String seasonTeam1Id, seasonTeam2Id;

  String seasonId;

  int team1Goals, team2Goals;

  int leagueMatch;
  DateTime matchDate;

  // Leave this as temporary
  // String team1Name, team2Name;
  Team team1, team2;

  List<MatchPlayerData> playersData;

  String matchNotes;

  Match() {
    id = DbUtils.newUuid();
  }

  Match.empty(String categoryId, String seasonId, String team1ImageFilename, String team2ImageFilename) {
    id = DbUtils.newUuid();
    this.categoryId = categoryId;
    this.seasonId = seasonId;
    // team1Id = uuid.v4(); removed to allow detecting if a team is inserted or not in Match View
    // team2Id = uuid.v4();
    team1Goals = 0;
    team2Goals = 0;
    leagueMatch = 0;
    matchDate = DateTime.now();
    team1 = Team.nameWithNoId("Squadra 1", team1ImageFilename);
    team2 = Team.nameWithNoId("Squadra 2", team2ImageFilename);
    matchNotes = "";
  }

  Match.clone(Match match) {
    id = match.id;
    categoryId = match.categoryId;
    seasonId = match.seasonId;
    setSeasonTeam1(match.getSeasonTeam1());
    setSeasonTeam2(match.getSeasonTeam2());
    team1Goals = match.team1Goals;
    team2Goals = match.team2Goals;
    leagueMatch = match.leagueMatch;
    matchDate = MyDateUtils.fromDateTime(match.matchDate);
    playersData = match.playersData == null ? List() : List.generate(match.playersData.length, (index) => MatchPlayerData.clone(match.playersData[index]));
    matchNotes = match.matchNotes;
  }

  /// If leagueMatch is null consider it as zero
  static int compare(Match m1, Match m2) {
    int leagueMatch1 = m1.leagueMatch;
    int leagueMatch2 = m2.leagueMatch;
    if(leagueMatch1 == null) {
      leagueMatch1 = 0;
    }
    if(leagueMatch2 == null) {
      leagueMatch2 = 0;
    }
    return leagueMatch1.compareTo(leagueMatch2);
  }

  SeasonTeam getSeasonTeam1() {
    SeasonTeam seasonTeam;
    if(team1.id == null) {
      seasonTeam = SeasonTeam();
    } else {
      seasonTeam = SeasonTeam.empty(team1.id, seasonId);
    }
    seasonTeam.id = seasonTeam1Id;
    seasonTeam.team = team1;
    return seasonTeam;
  }

  SeasonTeam getSeasonTeam2() {
    SeasonTeam seasonTeam;
    if(team2.id == null) {
      seasonTeam = SeasonTeam();
    } else {
      seasonTeam = SeasonTeam.empty(team2.id, seasonId);
    }
    seasonTeam.id = seasonTeam2Id;
    seasonTeam.team = team2;
    return seasonTeam;
  }

  Team getHomeTeam() {
    return getSeasonTeam1().team;
  }

  Team getAwayTeam() {
    return getSeasonTeam2().team;
  }

  String getHomeSeasonTeamId() {
    return getSeasonTeam1().id;
  }

  String getAwaySeasonTeamId() {
    return getSeasonTeam2().id;
  }

  String getHomeSeasonTeamName() {
    return getSeasonTeam1().team.name;
  }

  String getAwaySeasonTeamName() {
    return getSeasonTeam2().team.name;
  }

  String getHomeSeasonTeamImage() {
    return getSeasonTeam1().team.imageFilename;
  }

  String getAwaySeasonTeamImage() {
    return getSeasonTeam2().team.imageFilename;
  }

  List<MatchPlayerData> getHomePlayers() {
    return _getPlayers(getHomeSeasonTeamId());
  }

  List<MatchPlayerData> getAwayPlayers() {
    return _getPlayers(getAwaySeasonTeamId());
  }

  List<MatchPlayerData> getHomeRegularPlayers() {
    return getRegularPlayers(getHomeSeasonTeamId());
  }

  List<MatchPlayerData> getAwayRegularPlayers() {
    return getRegularPlayers(getAwaySeasonTeamId());
  }

  List<MatchPlayerData> getHomeReservePlayers() {
    return getReservePlayers(getHomeSeasonTeamId());
  }

  List<MatchPlayerData> getAwayReservePlayers() {
    return getReservePlayers(getAwaySeasonTeamId());
  }

  List<MatchPlayerData> getRegularPlayers(String seasonTeamId) {
    return _getLineUpPlayers(seasonTeamId, true);
  }

  List<MatchPlayerData> getReservePlayers(String seasonTeamId) {
    return _getLineUpPlayers(seasonTeamId, false);
  }

  List<MatchPlayerData> _getPlayers(String seasonTeamId) {
    return playersData.where((p) => p.seasonTeamId == seasonTeamId).toList();
  }

  List<MatchPlayerData> _getLineUpPlayers(String seasonTeamId, bool isRegular) {
    return playersData.where((p) => p.seasonTeamId == seasonTeamId && p.isRegular == isRegular).toList();
  }

  void setSeasonTeam1(SeasonTeam seasonTeam) {
    seasonTeam1Id = seasonTeam.id;
    team1 = seasonTeam.team;
  }

  void setSeasonTeam2(SeasonTeam seasonTeam) {
    seasonTeam2Id = seasonTeam.id;
    team2 = seasonTeam.team;
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'categoryId': categoryId,
      'seasonTeam1Id': seasonTeam1Id,
      'seasonTeam2Id': seasonTeam2Id,
      'seasonId': seasonId,
      'team1Goals': team1Goals,
      'team2Goals': team2Goals,
      'leagueMatch': leagueMatch,
      'matchDate': matchDate.toIso8601String(),
      'playersData': playersData == null ? List() : List.generate(
          playersData.length, (index) => playersData[index].toJson()),
      'matchNotes': matchNotes == null ? "" : matchNotes
    };
  }

  Match.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      categoryId = json['categoryId'],
      seasonTeam1Id = json['seasonTeam1Id'],
      seasonTeam2Id = json['seasonTeam2Id'],
      seasonId = json['seasonId'],
      team1Goals = json['team1Goals'],
      team2Goals = json['team2Goals'],
      leagueMatch = json['leagueMatch'],
      matchDate = DateTime.tryParse(json['matchDate']),
      playersData = json['playersData'] == null ? List() : List.generate(json['playersData'].length, (index) => MatchPlayerData.fromJson(json['playersData'][index])),
      matchNotes = json['matchNotes'] == null ? "" : json['matchNotes'];

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("categoryId", categoryId);
    Preconditions.requireFieldNotEmpty("seasonTeam1Id", seasonTeam1Id);
    Preconditions.requireFieldNotEmpty("seasonTeam2Id", seasonTeam2Id);
    Preconditions.requireFieldNotEmpty("seasonId", seasonId);
    Preconditions.requireFieldNotNull("matchDate", matchDate);
  }
}