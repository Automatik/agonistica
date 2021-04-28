import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/exceptions/integrity_exception.dart';
import 'package:agonistica/core/exceptions/not_found_exception.dart';
import 'package:agonistica/core/models/followed_players.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/repositories/player_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/services/followed_players_service.dart';
import 'package:agonistica/core/services/season_player_service.dart';
import 'package:firebase_database/firebase_database.dart';

class PlayerService extends CrudService<Player> {

  PlayerService(DatabaseReference databaseReference)
    : super(databaseReference, PlayerRepository(databaseReference, locator<AppStateService>().selectedAppUser.id));

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
    FollowedPlayersService followedPlayersService = FollowedPlayersService(databaseReference);
    String followedPlayersId = await followedPlayersService.findPlayerIdInFollowedPlayers(playerId);
    bool isPlayerFollowed = followedPlayersId != null;
    if(isPlayerFollowed) {
      FollowedPlayers followedPlayers = await followedPlayersService.getItemById(followedPlayersId);
      await followedPlayersService.unFollowPlayer(followedPlayers, playerId);
    }

    await super.deleteItem(playerId);
  }

  Future<void> deletePlayersInCategory(String categoryId) async {
    List<Player> players = await getAllItems();
    SeasonPlayerService seasonPlayerService = SeasonPlayerService(databaseReference);
    players.forEach((p) async {
      List<SeasonPlayer> seasonPlayers = await seasonPlayerService.getItemsByIds(p.seasonPlayersIds);
      await seasonPlayerService.deleteSeasonPlayersInCategory(seasonPlayers, categoryId);
      // TODO Delete player if there are no more seasonPlayers?
      // if(seasonPlayers.length <= 1) {
      //   await deleteItem(p.id);
      // }
    });
  }

  Future<void> addSeasonPlayerToPlayer(String seasonPlayerId, Player player) async {
    player.addSeasonPlayer(seasonPlayerId);
    await super.saveItem(player);
  }

  Future<void> deleteSeasonPlayerFromPlayer(String seasonPlayerId, Player player) async {
    player.removeSeasonPlayer(seasonPlayerId);
    await super.saveItem(player);
  }

}