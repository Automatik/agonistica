import 'package:agonistica/core/models/followed_players.dart';
import 'package:agonistica/core/repositories/followed_players_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:firebase_database/firebase_database.dart';

class FollowedPlayersService extends CrudService<FollowedPlayers> {

  FollowedPlayersService(DatabaseReference databaseReference)
      : super(databaseReference, FollowedPlayersRepository(databaseReference));

  Future<bool> isPlayerFollowed(String playerId, {String followedPlayersId}) async {
    if(followedPlayersId == null || followedPlayersId.isEmpty) {
      FollowedPlayers followedPlayers = await getItemById(followedPlayersId);
      return followedPlayers.playersIds.contains(playerId);
    }
    List<FollowedPlayers> followedPlayersList = await getAllItems();
    for(FollowedPlayers followedTeams in followedPlayersList) {
      if(followedTeams.playersIds.contains(playerId)) {
        return true;
      }
    }
    return false;
  }

  Future<FollowedPlayers> followPlayer(String followedPlayersId, String playerId) async {
    FollowedPlayers followedPlayers = await getItemById(followedPlayersId);
    followedPlayers.addPlayer(playerId);
    await super.saveItem(followedPlayers);
    return followedPlayers;
  }

  Future<FollowedPlayers> unFollowPlayer(String followedPlayersId, String playerId) async {
    FollowedPlayers followedPlayers = await getItemById(followedPlayersId);
    followedPlayers.removePlayer(playerId);
    await super.saveItem(followedPlayers);
    return followedPlayers;
  }

}