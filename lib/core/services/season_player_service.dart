import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/repositories/season_player_repository.dart';
import 'package:agonistica/core/services/category_service.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/services/match_service.dart';
import 'package:agonistica/core/services/player_notes_service.dart';
import 'package:agonistica/core/services/player_service.dart';
import 'package:agonistica/core/services/season_team_service.dart';
import 'package:agonistica/core/utils/db_utils.dart';
import 'package:firebase_database/firebase_database.dart';

class SeasonPlayerService extends CrudService<SeasonPlayer> {

  SeasonPlayerService(DatabaseReference databaseReference)
    : super(databaseReference, SeasonPlayerRepository(databaseReference));

  // SET

  @override
  Future<void> saveItem(SeasonPlayer seasonPlayer) async {
    // Before creating a seasonPlayer be sure that a Player exists

    PlayerService playerService = PlayerService(databaseReference);
    await playerService.createPlayerFromSeasonPlayer(seasonPlayer);

    // add seasonPlayerId to player's seasonPlayerIds
    Player player = await playerService.getItemById(seasonPlayer.playerId);
    seasonPlayer.player = player;
    await playerService.addSeasonPlayerToPlayer(seasonPlayer.id, player);

    // if the player's teamId is changed, remove the player's id from the old team's playersIds
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    bool seasonPlayerAlreadyExists = await itemExists(seasonPlayer.id);
    if(seasonPlayerAlreadyExists) {
      SeasonPlayer oldSeasonPlayer = await getItemById(seasonPlayer.id);
      if(oldSeasonPlayer.seasonTeamId != seasonPlayer.seasonTeamId) {
        bool oldSeasonTeamExists = await seasonTeamService.itemExists(oldSeasonPlayer.seasonTeamId);
        if(oldSeasonTeamExists) {
          SeasonTeam oldSeasonTeam = await seasonTeamService.getItemById(oldSeasonPlayer.seasonTeamId);
          await seasonTeamService.deleteSeasonPlayerFromSeasonTeam(oldSeasonTeam, oldSeasonPlayer.id);
        }
      }
    }

    // if the player's team doesn't exist, create it
    bool teamExists = await seasonTeamService.itemExists(seasonPlayer.seasonTeamId);
    if(!teamExists) {
      SeasonTeam seasonTeam = seasonPlayer.getSeasonTeam();
      await seasonTeamService.saveItem(seasonTeam);
    }

    await super.saveItem(seasonPlayer);

    // insert or update team's playerIds
    SeasonTeam seasonTeam = await seasonTeamService.getItemById(seasonPlayer.seasonTeamId);
    await seasonTeamService.addSeasonPlayerToSeasonTeam(seasonTeam, seasonPlayer.id);

    // update for every match that the player has played the player's name
    MatchService matchService = MatchService(databaseReference);
    await matchService.updateMatchPlayersNamesFromSeasonPlayer(seasonPlayer);

    // insert or update player's match notes separately
  }

  Future<void> saveSeasonPlayerIfNotExists(SeasonPlayer seasonPlayer) async {
    bool seasonPlayerExists = await itemExists(seasonPlayer.id);
    if(!seasonPlayerExists) {
      await saveItem(seasonPlayer);
    }
  }

  Future<void> addMatchIdToSeasonPlayer(String matchId, SeasonPlayer seasonPlayer) async {
    seasonPlayer.addMatch(matchId);
    await super.saveItem(seasonPlayer);
  }

  Future<void> addPlayerMatchNotesIdToSeasonPlayer(String playerMatchNotesId, SeasonPlayer seasonPlayer) async {
    // update player's playerMatchNodesIds
    seasonPlayer.addPlayerMatchNotesId(playerMatchNotesId);
    await super.saveItem(seasonPlayer);
  }

  // GET

  /// Download players of the given team and category
  Future<List<SeasonPlayer>> getSeasonPlayersByTeamAndCategory(String seasonTeamId, String categoryId) async {
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    bool seasonTeamExists = await seasonTeamService.itemExists(seasonTeamId);
    if(!seasonTeamExists) {
      return Future.value(List<SeasonPlayer>());
    }
    SeasonTeam seasonTeam = await seasonTeamService.getItemById(seasonTeamId);
    if(seasonTeam.seasonPlayersIds == null || seasonTeam.seasonPlayersIds.isEmpty)
      return Future.value(List<SeasonPlayer>());
    if (DbUtils.listContainsNulls(seasonTeam.seasonPlayersIds)) {
      CrudService.logger.w("The seasonTeam with id $seasonTeamId contains null values in seasonPlayersIds");
      seasonTeam.seasonPlayersIds = DbUtils.removeNullValues(seasonTeam.seasonPlayersIds);
    }
    List<SeasonPlayer> players = await getItemsByIds(seasonTeam.seasonPlayersIds);
    players.removeWhere((player) => player.categoryId != categoryId);
    return players;
  }

  Future<List<SeasonPlayer>> getSeasonPlayersWithCategoryAndSeasonFromPlayers(String categoryId, String seasonId, List<Player> players) async {
    List<SeasonPlayer> seasonPlayers = [];
    players.forEach((p) async {
      List<SeasonPlayer> playerSeasonPlayers = await getItemsByIds(p.seasonPlayersIds);
      int index = playerSeasonPlayers.indexWhere((sp) => sp.categoryId == categoryId && sp.seasonId == seasonId);
      if(index != -1) {
        SeasonPlayer seasonPlayer = playerSeasonPlayers[index];
        seasonPlayers.add(seasonPlayer);
      }
    });
    return seasonPlayers;
  }

  Future<List<SeasonPlayer>> completeSeasonPlayersWithMissingInfo(List<SeasonPlayer> seasonPlayers) async {
    for(SeasonPlayer seasonPlayer in seasonPlayers) {
      seasonPlayer = await completeSeasonPlayerWithMissingInfo(seasonPlayer);
    }
    return seasonPlayers;
  }

  /// Download missing info for a player (for instance after calling getPlayerId)
  /// like the team's name and the category's name
  Future<SeasonPlayer> completeSeasonPlayerWithMissingInfo(SeasonPlayer seasonPlayer) async {
    CategoryService categoryService = CategoryService(databaseReference);
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    PlayerService playerService = PlayerService(databaseReference);

    String categoryId = seasonPlayer.categoryId;
    String seasonTeamId = seasonPlayer.seasonTeamId;
    String playerId = seasonPlayer.playerId;

    Category category = await categoryService.getItemById(categoryId);
    SeasonTeam seasonTeam = await seasonTeamService.getFullSeasonTeamById(seasonTeamId);
    Player player = await playerService.getItemById(playerId);

    seasonPlayer.categoryName = category.name;
    seasonPlayer.seasonTeam = seasonTeam;
    seasonPlayer.player = player;

    return seasonPlayer;
  }

  // DELETE

  @override
  Future<void> deleteItem(String seasonPlayerId) async {
    SeasonPlayer seasonPlayer = await getItemById(seasonPlayerId);

    // Delete season player from player
    PlayerService playerService = PlayerService(databaseReference);
    Player player = await playerService.getItemById(seasonPlayer.playerId);
    await playerService.deleteSeasonPlayerFromPlayer(seasonPlayerId, player);

    // Delete season player id from team
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    SeasonTeam seasonTeam = await seasonTeamService.getItemById(seasonPlayer.seasonTeamId);
    await seasonTeamService.deleteSeasonPlayerFromSeasonTeam(seasonTeam, seasonPlayerId);

    // Delete season player id from the matches he has played
    MatchService matchService = MatchService(databaseReference);
    List<Match> matches = await matchService.getItemsByIds(seasonPlayer.matchesIds);
    await matchService.deleteSeasonPlayerFromMatchesIds(matches, seasonPlayerId);

    // Delete season player's match notes
    PlayerNotesService playerNotesService = PlayerNotesService(databaseReference);
    await playerNotesService.deletePlayerNotesFromIds(seasonPlayer.playerMatchNotesIds);

    await super.deleteItem(seasonPlayerId);
  }

  Future<void> deleteSeasonPlayersByIds(List<String> seasonPlayersIds) async {
    seasonPlayersIds.forEach((id) async {
      await super.deleteItem(id);
    });
  }

  Future<void> deleteSeasonPlayersInCategory(List<SeasonPlayer> seasonPlayers, String categoryId) async {
    seasonPlayers.forEach((sp) async {
      if(sp.categoryId == categoryId) {
        await deleteItem(sp.id);
      }
    });
  }

  /// Delete a match's id from the season player's matchesIds list
  Future<void> deleteMatchFromSeasonPlayer(SeasonPlayer seasonPlayer, String matchId) async {
    // Remove match id from matchesIds
    seasonPlayer.removeMatch(matchId);

    // Remove player match notes id from playerMatchNotesIds
    PlayerNotesService playerNotesService = PlayerNotesService(databaseReference);
    String playerMatchNotesId = await playerNotesService
        .findPlayerMatchNoteIdOfMatchFromList(seasonPlayer.playerMatchNotesIds, matchId);
    if(playerMatchNotesId == null) {
      CrudService.logger.d("Should be ok if no playerMatchNote is found for the given match with id $matchId");
    } else {
      await removePlayerMatchNotesIdFromSeasonPlayer(
          playerMatchNotesId, seasonPlayer);
    }

    await super.saveItem(seasonPlayer);
  }

  Future<void> removePlayerMatchNotesIdFromSeasonPlayer(String playerMatchNotesId, SeasonPlayer seasonPlayer) async {
    seasonPlayer.removePlayerMatchNotesId(playerMatchNotesId);
    await super.saveItem(seasonPlayer);
  }


}