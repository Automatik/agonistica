

import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/followed_players.dart';
import 'package:agonistica/core/repositories/followed_players_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/utils/db_utils.dart';
import 'package:firebase_database/firebase_database.dart';

class FollowedPlayersService extends CrudService<FollowedPlayers> {

  FollowedPlayersService(DatabaseReference databaseReference)
      : super(databaseReference, FollowedPlayersRepository(databaseReference, locator<AppStateService>().selectedAppUser!.id));

  @override
  Future<void> saveItem(FollowedPlayers followedPlayers) async {
    FollowedPlayers existingFollowedPlayers = await getFollowedPlayers();
    bool isSameObject = existingFollowedPlayers.id == followedPlayers.id;
    if(isSameObject) {
      await super.saveItem(followedPlayers);
    } else {
      List<String> mergedPlayersIds = DbUtils.mergeLists(existingFollowedPlayers.playersIds!, followedPlayers.playersIds!) as List<String>;
      existingFollowedPlayers.playersIds = mergedPlayersIds;
      await super.saveItem(existingFollowedPlayers);
    }
  }

  Future<bool> isPlayerFollowed(String playerId) async {
    FollowedPlayers followedPlayers = await getFollowedPlayers();
    return followedPlayers.playersIds!.contains(playerId);
  }

  Future<void> followPlayer(String playerId) async {
    FollowedPlayers followedPlayers = await getFollowedPlayers();
    followedPlayers.addPlayer(playerId);
    await super.saveItem(followedPlayers);
  }

  Future<void> unFollowPlayer(String playerId) async {
    FollowedPlayers followedPlayers = await getFollowedPlayers();
    followedPlayers.removePlayer(playerId);
    await super.saveItem(followedPlayers);
  }

  /// Get the user's FollowedPlayers object. Assume there is only one FollowedPlayers
  /// object. Return a new object if there are no followed players yet
  Future<FollowedPlayers> getFollowedPlayers() async {
    // get user FollowedTeams objects
    List<FollowedPlayers> followedPlayersList = await getAllItems();
    // Assume there is only one FollowedTeams object
    FollowedPlayers followedPlayers;
    if(followedPlayersList.isEmpty) {
      followedPlayers = FollowedPlayers.empty();
    } else {
      followedPlayers = followedPlayersList[0];
    }
    return followedPlayers;
  }

}