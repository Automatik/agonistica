import 'package:agonistica/core/exceptions/integrity_exception.dart';
import 'package:agonistica/core/exceptions/not_found_exception.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/repositories/player_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/services/season_player_service.dart';
import 'package:firebase_database/firebase_database.dart';

class PlayerService extends CrudService<Player> {

  PlayerService(DatabaseReference databaseReference)
    : super(databaseReference, PlayerRepository(databaseReference));

  Future<void> createPlayerFromSeasonPlayer(SeasonPlayer seasonPlayer) async {
    bool playerExists = await itemExists(seasonPlayer.playerId);
    if(!playerExists) {
      if(seasonPlayer.player == null) {
        throw NotFoundException("Player with id ${seasonPlayer.playerId} does not "
            "exist and player attribute of SeasonPlayer object is null. Can't "
            "create a Player with no name");
      }
      if(seasonPlayer.player.id != seasonPlayer.playerId) {
        throw IntegrityException("seasonPlayer.player.id must be equal to seasonPlayer.playerId");
      }
      Player player = seasonPlayer.player;
      player.addSeasonPlayer(seasonPlayer.id);
      await super.saveItem(player);
    }
  }

  @override
  Future<void> deleteItem(String playerId) async {
    Player player = await getItemById(playerId);

    // Delete season players for this player
    SeasonPlayerService seasonPlayerService = SeasonPlayerService(databaseReference);
    for(String seasonPlayerId in player.seasonPlayersIds) {
      await seasonPlayerService.deleteItem(seasonPlayerId);
    }

    //TODO Unfollow player (get user' followedPlayers and then call followedPlayers.unFollow)

    await super.deleteItem(playerId);
  }

  Future<Player> addSeasonPlayerToPlayer(String seasonPlayerId, String playerId) async {
    Player player = await getItemById(playerId);
    player.addSeasonPlayer(seasonPlayerId);
    await super.saveItem(player);
    return player;
  }

  Future<Player> deleteSeasonPlayerFromPlayer(String seasonPlayerId, String playerId) async {
    Player player = await getItemById(playerId);
    player.removeSeasonPlayer(seasonPlayerId);
    await super.saveItem(player);
    return player;
  }

}