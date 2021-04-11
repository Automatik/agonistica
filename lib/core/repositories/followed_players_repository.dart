import 'package:agonistica/core/models/followed_players.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class FollowedPlayersRepository extends CrudRepository<FollowedPlayers> {

  FollowedPlayersRepository(DatabaseReference databaseReference)
      : super(databaseReference, DatabaseService.firebaseFollowedPlayersChild);

  // SET

  Future<void> saveFollowedPlayers(FollowedPlayers followedPlayers) async {
    await super.saveItem(followedPlayers.id, followedPlayers);
  }

  // GET

  Future<FollowedPlayers> getFollowedPlayersById(String followedPlayersId) async {
    return await super.getItemById(followedPlayersId);
  }

  Future<bool> isPlayerFollowed(String playerId, {String followedPlayersId}) async {
    if(followedPlayersId == null || followedPlayersId.isEmpty) {
      FollowedPlayers followedPlayers = await getFollowedPlayersById(followedPlayersId);
      return followedPlayers.playersIds.contains(playerId);
    }
    List<FollowedPlayers> followedPlayersList = await super.getAllItems();
    for(FollowedPlayers followedTeams in followedPlayersList) {
      if(followedTeams.playersIds.contains(playerId)) {
        return true;
      }
    }
    return false;
  }

  // DELETE

  Future<void> deleteFollowedPlayers(String followedPlayersId) async {
    await super.deleteItem(followedPlayersId);
  }

  @override
  Map<String, dynamic> itemToJson(FollowedPlayers t) {
    return t.toJson();
  }

  @override
  FollowedPlayers jsonToItem(Map<dynamic, dynamic> json) {
    return FollowedPlayers.fromJson(json);
  }

}