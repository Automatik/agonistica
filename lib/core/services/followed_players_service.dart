import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/followed_players.dart';
import 'package:agonistica/core/repositories/followed_players_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:firebase_database/firebase_database.dart';

class FollowedPlayersService extends CrudService<FollowedPlayers> {

  FollowedPlayersService(DatabaseReference databaseReference)
      : super(databaseReference, FollowedPlayersRepository(databaseReference, locator<AppStateService>().selectedAppUser.id));

  Future<bool> isPlayerFollowed(String playerId, {String followedPlayersId}) async {
    if(followedPlayersId != null && followedPlayersId.isNotEmpty) {
      FollowedPlayers followedPlayers = await getItemById(followedPlayersId);
      return followedPlayers.playersIds.contains(playerId);
    }
    String followedPlayersIdTemp = await findPlayerIdInFollowedPlayers(playerId);
    bool isPlayerFollowed = followedPlayersIdTemp != null;
    return isPlayerFollowed;
  }

  Future<String> findPlayerIdInFollowedPlayers(String playerId) async {
    List<FollowedPlayers> followedPlayersList = await getAllItems();
    int i = 0;
    while(i < followedPlayersList.length) {
      FollowedPlayers followedPlayers = followedPlayersList[i];
      if(followedPlayers.playersIds.contains(playerId)) {
        return followedPlayers.id;
      }
      i++;
    }
    return null;
  }

  Future<void> followPlayer(FollowedPlayers followedPlayers, String playerId) async {
    followedPlayers.addPlayer(playerId);
    await super.saveItem(followedPlayers);
  }

  Future<void> unFollowPlayer(FollowedPlayers followedPlayers, String playerId) async {
    followedPlayers.removePlayer(playerId);
    await super.saveItem(followedPlayers);
  }

}