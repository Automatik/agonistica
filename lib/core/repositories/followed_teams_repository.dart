import 'package:agonistica/core/models/followed_teams.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class FollowedTeamsRepository extends CrudRepository<FollowedTeams> {

  FollowedTeamsRepository(DatabaseReference databaseReference)
      : super(databaseReference, DatabaseService.firebaseFollowedTeamsChild);

  // SET

  Future<void> saveFollowedTeams(FollowedTeams followedTeams) async {
    await super.saveItem(followedTeams);
  }

  // GET

  Future<FollowedTeams> getFollowedTeamsById(String followedTeamsId) async {
    return await super.getItemById(followedTeamsId);
  }

  Future<bool> isTeamFollowed(String teamId, {String followedTeamsId}) async {
    if(followedTeamsId == null || followedTeamsId.isEmpty) {
      FollowedTeams followedTeams = await getFollowedTeamsById(followedTeamsId);
      return followedTeams.teamsIds.contains(teamId);
    }
    List<FollowedTeams> followedTeamsList = await super.getAllItems();
    for(FollowedTeams followedTeams in followedTeamsList) {
      if(followedTeams.teamsIds.contains(teamId)) {
        return true;
      }
    }
    return false;
  }

  // DELETE

  Future<void> deleteFollowedTeams(String followedTeamsId) async {
    await super.deleteItem(followedTeamsId);
  }

  @override
  Map<String, dynamic> itemToJson(FollowedTeams t) {
    return t.toJson();
  }

  @override
  FollowedTeams jsonToItem(Map<dynamic, dynamic> json) {
    return FollowedTeams.fromJson(json);
  }

  @override
  String getItemId(FollowedTeams item) {
    return item.id;
  }

}