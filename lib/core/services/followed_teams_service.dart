

import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/followed_teams.dart';
import 'package:agonistica/core/repositories/followed_teams_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/utils/db_utils.dart';
import 'package:firebase_database/firebase_database.dart';

class FollowedTeamsService extends CrudService<FollowedTeams> {

  FollowedTeamsService(DatabaseReference databaseReference)
    : super(databaseReference, FollowedTeamsRepository(databaseReference, locator<AppStateService>().selectedAppUser!.id));


  @override
  Future<void> saveItem(FollowedTeams followedTeams) async {
    FollowedTeams existingFollowedTeams = await getFollowedTeams();
    bool isSameObject = existingFollowedTeams.id == followedTeams.id;
    if(isSameObject) {
      await super.saveItem(followedTeams);
    } else {
      List<String> mergedTeamsIds = DbUtils.mergeLists(existingFollowedTeams.teamsIds!, followedTeams.teamsIds!) as List<String>;
      existingFollowedTeams.teamsIds = mergedTeamsIds;
      await super.saveItem(existingFollowedTeams);
    }
  }

  Future<bool> isTeamFollowed(String teamId) async {
    FollowedTeams followedTeams = await getFollowedTeams();
    return followedTeams.teamsIds!.contains(teamId);
  }

  Future<void> followTeam(String teamId) async {
    FollowedTeams followedTeams = await getFollowedTeams();
    followedTeams.addTeam(teamId);
    await super.saveItem(followedTeams);
  }

  Future<void> unFollowTeam(String teamId) async {
    FollowedTeams followedTeams = await getFollowedTeams();
    followedTeams.removeTeam(teamId);
    await super.saveItem(followedTeams);
  }

  /// Get the user's FollowedTeams object. Assume there is only one FollowedTeams
  /// object. Return a new object if there are no followed teams yet
  Future<FollowedTeams> getFollowedTeams() async {
    // get user FollowedTeams objects
    List<FollowedTeams> followedTeamsList = await getAllItems();
    // Assume there is only one FollowedTeams object
    FollowedTeams followedTeams;
    if(followedTeamsList.isEmpty) {
      followedTeams = FollowedTeams.empty();
    } else {
      followedTeams = followedTeamsList[0];
    }
    return followedTeams;
  }

}