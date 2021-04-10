import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/models/match_player_data.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/utils/date_utils.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class Match {

  String id;

  String categoryId;

  String seasonTeam1Id, seasonTeam2Id;

  int team1Goals, team2Goals;

  int leagueMatch;
  DateTime matchDate;

  // Leave this as temporary
  String team1Name, team2Name;

  List<MatchPlayerData> playersData;

  String matchNotes;

  Match() {
    id = DbUtils.newUuid();
  }

  Match.empty() {
    id = DbUtils.newUuid();
    categoryId = DbUtils.newUuid();
    // team1Id = uuid.v4(); removed to allow detecting if a team is inserted or not in Match View
    // team2Id = uuid.v4();
    team1Goals = 0;
    team2Goals = 0;
    leagueMatch = 0;
    matchDate = DateTime.now();
    team1Name = "Squadra 1";
    team2Name = "Squadra 2";
    matchNotes = "";
  }

  Match.clone(Match match) {
    id = match.id;
    categoryId = match.categoryId;
    setTeam1(match.getTeam1());
    setTeam2(match.getTeam2());
    team1Goals = match.team1Goals;
    team2Goals = match.team2Goals;
    leagueMatch = match.leagueMatch;
    matchDate = DateUtils.fromDateTime(match.matchDate);
    playersData = match.playersData == null ? List() : List.generate(match.playersData.length, (index) => MatchPlayerData.clone(match.playersData[index]));
    matchNotes = match.matchNotes;
  }

  Team getTeam1() {
    Team team = Team.name(team1Name);
    team.id = seasonTeam1Id;
    return team;
  }

  Team getTeam2() {
    Team team = Team.name(team2Name);
    team.id = seasonTeam2Id;
    return team;
  }

  String getHomeTeamId() {
    return getTeam1().id;
  }

  String getAwayTeamId() {
    return getTeam2().id;
  }

  List<MatchPlayerData> getHomePlayers() {
    return _getPlayers(getHomeTeamId());
  }

  List<MatchPlayerData> getAwayPlayers() {
    return _getPlayers(getAwayTeamId());
  }

  List<MatchPlayerData> getHomeRegularPlayers() {
    return getRegularPlayers(getHomeTeamId());
  }

  List<MatchPlayerData> getAwayRegularPlayers() {
    return getRegularPlayers(getAwayTeamId());
  }

  List<MatchPlayerData> getHomeReservePlayers() {
    return getReservePlayers(getHomeTeamId());
  }

  List<MatchPlayerData> getAwayReservePlayers() {
    return getReservePlayers(getAwayTeamId());
  }

  List<MatchPlayerData> getRegularPlayers(String teamId) {
    return _getLineUpPlayers(teamId, true);
  }

  List<MatchPlayerData> getReservePlayers(String teamId) {
    return _getLineUpPlayers(teamId, false);
  }

  List<MatchPlayerData> _getPlayers(String teamId) {
    return playersData.where((p) => p.seasonTeamId == teamId).toList();
  }

  List<MatchPlayerData> _getLineUpPlayers(String teamId, bool isRegular) {
    return playersData.where((p) => p.seasonTeamId == teamId && p.isRegular == isRegular).toList();
  }

  void setTeam1(Team team) {
    seasonTeam1Id = team.id;
    team1Name = team.name;
  }

  void setTeam2(Team team) {
    seasonTeam2Id = team.id;
    team2Name = team.name;
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'categoryId': categoryId,
      'seasonTeam1Id': seasonTeam1Id,
      'seasonTeam2Id': seasonTeam2Id,
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
    Preconditions.requireFieldNotNull("matchDate", matchDate);
  }
}