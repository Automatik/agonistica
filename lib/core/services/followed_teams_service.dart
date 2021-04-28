import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/followed_teams.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/repositories/followed_teams_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/services/team_service.dart';
import 'package:firebase_database/firebase_database.dart';

class FollowedTeamsService extends CrudService<FollowedTeams> {

  FollowedTeamsService(DatabaseReference databaseReference)
    : super(databaseReference, FollowedTeamsRepository(databaseReference, locator<AppStateService>().selectedAppUser.id));


  // GET

  Future<bool> isTeamFollowed(String teamId, {String followedTeamsId}) async {
    if(followedTeamsId != null && followedTeamsId.isNotEmpty) {
      FollowedTeams followedTeams = await getItemById(followedTeamsId);
      return followedTeams.teamsIds.contains(teamId);
    }
    String followedTeamsIdTemp = await findTeamIdInFollowedTeams(teamId);
    bool isTeamFollowed = followedTeamsIdTemp != null;
    return isTeamFollowed;
  }

  Future<String> findTeamIdInFollowedTeams(String teamId) async {
    List<FollowedTeams> followedTeamsList = await getAllItems();
    int i = 0;
    while(i < followedTeamsList.length) {
      FollowedTeams followedTeams = followedTeamsList[i];
      if(followedTeams.teamsIds.contains(teamId)) {
        return followedTeams.id;
      }
      i++;
    }
    return null;
  }

  Future<void> followTeam(FollowedTeams followedTeams, String teamId) async {
    followedTeams.addTeam(teamId);
    await super.saveItem(followedTeams);
  }

  Future<void> unFollowTeam(FollowedTeams followedTeams, String teamId) async {
    followedTeams.removeTeam(teamId);
    await super.saveItem(followedTeams);
  }

  //TODO Riscrivere prendendo i team seguiti dell'utente da firebase
  Future<List<Team>> getUserFollowedTeams() async {
    List<FollowedTeams> followedTeamsList = await getAllItems();
    FollowedTeams followedTeams = followedTeamsList[0]; //for now take the first, after should take the user's followed teams
    TeamService teamService = TeamService(databaseReference);
    List<Team> teams = await teamService.getItemsByIds(followedTeams.teamsIds);
    return teams;
  }

  //TODO Riscrivere usando i team seguiti dall'utente da firebase
  /// Download all teams without the other requested teams (merateTeam and other)
  // Future<List<Team>> getAllNonFollowedTeams() async {
  //   SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
  //   final sharedPref = await SharedPreferences.getInstance();
  //   List<String> requestedTeamsIds = sharedPref.getStringList(requestedTeamsIdsKey);
  //   return await seasonTeamService.getTeamsWithoutIds(requestedTeamsIds);
  // }

}