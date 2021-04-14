import 'package:agonistica/core/models/followed_teams.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/repositories/followed_teams_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/services/season_team_service.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowedTeamsService extends CrudService<FollowedTeams> {

  FollowedTeamsService(DatabaseReference databaseReference)
    : super(databaseReference, FollowedTeamsRepository(databaseReference));


  // GET

  Future<bool> isTeamFollowed(String teamId, {String followedTeamsId}) async {
    if(followedTeamsId == null || followedTeamsId.isEmpty) {
      FollowedTeams followedTeams = await getItemById(followedTeamsId);
      return followedTeams.teamsIds.contains(teamId);
    }
    List<FollowedTeams> followedTeamsList = await getAllItems();
    for(FollowedTeams followedTeams in followedTeamsList) {
      if(followedTeams.teamsIds.contains(teamId)) {
        return true;
      }
    }
    return false;
  }

  Future<void> followTeam(String followedTeamsId, String teamId) async {
    FollowedTeams followedTeams = await getItemById(followedTeamsId);
    followedTeams.teamsIds.add(teamId);
    await super.saveItem(followedTeams);
  }

  Future<void> unFollowTeam(String followedTeamsId, String teamId) async {
    FollowedTeams followedTeams = await getItemById(followedTeamsId);
    followedTeams.teamsIds.removeWhere((id) => id == teamId);
    await super.saveItem(followedTeams);
  }

  //TODO Riscrivere prendendo i team seguiti dell'utente e di una certa stagione da firebase
  // Future<List<SeasonTeam>> getFollowedTeams() async {
  //   SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
  //   final sharedPref = await SharedPreferences.getInstance();
  //   List<String> teamsIds = sharedPref.getStringList(requestedTeamsIdsKey);
  //   return await seasonTeamService.getItemsByIds(teamsIds);
  // }

  //TODO Riscrivere usando i team seguiti dall'utente e di una certa stagione da firebase
  /// Download all teams without the other requested teams (merateTeam and other)
  // Future<List<SeasonTeam>> getAllNonFollowedTeams() async {
  //   SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
  //   final sharedPref = await SharedPreferences.getInstance();
  //   List<String> requestedTeamsIds = sharedPref.getStringList(requestedTeamsIdsKey);
  //   return await seasonTeamService.getTeamsWithoutIds(requestedTeamsIds);
  // }

}