import 'package:agonistica/core/exceptions/integrity_exception.dart';
import 'package:agonistica/core/exceptions/not_found_exception.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/repositories/season_player_repository.dart';
import 'package:agonistica/core/services/category_service.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/services/match_service.dart';
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
    bool playerExists = await playerService.itemExists(seasonPlayer.playerId);
    if(!playerExists) {
      if(seasonPlayer.player == null) {
        throw NotFoundException("Player with id ${seasonPlayer.playerId} does not "
            "exist and player attribute of SeasonPlayer object is null. Can't "
            "create a Player with no name");
      }
      if(seasonPlayer.player.id != seasonPlayer.playerId) {
        throw IntegrityException("seasonPlayer.player.id must be equal to seasonPlayer.playerId");
      }
      playerService.saveItem(seasonPlayer.player);
    }

    // if the player's teamId is changed, remove the player's id from the old team's playersIds
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    SeasonPlayer oldSeasonPlayer = await getItemById(seasonPlayer.id);
    if(oldSeasonPlayer != null && oldSeasonPlayer.seasonTeamId != seasonPlayer.seasonTeamId) {
      SeasonTeam oldSeasonTeam = await seasonTeamService.getItemById(oldSeasonPlayer.seasonTeamId);
      oldSeasonTeam.seasonPlayersIds.removeWhere((id) => id == oldSeasonPlayer.id);
      await seasonTeamService.saveItem(oldSeasonTeam);
    }

    await super.saveItem(seasonPlayer);

    // insert or update team's playerIds
    SeasonTeam seasonTeam = await seasonTeamService.getItemById(seasonPlayer.seasonTeamId);
    if(seasonTeam.seasonPlayersIds == null)
      seasonTeam.seasonPlayersIds = [];
    if(!seasonTeam.seasonPlayersIds.contains(seasonPlayer.id)) {
      seasonTeam.seasonPlayersIds.add(seasonPlayer.id);
      await seasonTeamService.saveItem(seasonTeam);
    }

    // update for every match that the player has played the player's name
    MatchService matchService = MatchService(databaseReference);
    List<Match> matches = await matchService.getItemsByIds(seasonPlayer.matchesIds);
    for(Match match in matches) {
      int index = match.playersData.indexWhere((data) => data.seasonPlayerId == seasonPlayer.id);
      if(index > -1) {
        Player player = seasonPlayer.player;
        match.playersData[index].name = player.name;
        match.playersData[index].surname = player.surname;
        matchService.saveItem(match);
      } else {
        CrudService.logger.d("MatchPlayerData not found from player's matchesIds."
            " Shouldn't happen! Player id: ${seasonPlayer.id} Match id: ${match.id}");
      }
    }

    // insert or update player's match notes separately
  }

  Future<void> saveSeasonPlayerIfNotExists(SeasonPlayer seasonPlayer) async {
    bool seasonPlayerExists = await super.itemExists(seasonPlayer.id);
    if(!seasonPlayerExists) {
      saveItem(seasonPlayer);
    }
  }

  // GET

  /// Download players of the given team and category
  Future<List<SeasonPlayer>> getSeasonPlayersByTeamAndCategory(String seasonTeamId, String categoryId) async {
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    SeasonTeam seasonTeam = await seasonTeamService.getItemById(seasonTeamId);
    if(seasonTeam == null || seasonTeam.seasonPlayersIds == null || seasonTeam.seasonPlayersIds.isEmpty)
      return Future.value(List<SeasonPlayer>());
    if (DbUtils.listContainsNulls(seasonTeam.seasonPlayersIds)) {
      CrudService.logger.w("The seasonTeam with id $seasonTeamId contains null values in seasonPlayersIds");
      seasonTeam.seasonPlayersIds = DbUtils.removeNullValues(seasonTeam.seasonPlayersIds);
    }
    List<SeasonPlayer> players = await getItemsByIds(seasonTeam.seasonPlayersIds);
    players.removeWhere((player) => player.categoryId != categoryId);
    return players;
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

    // Delete season player id from team
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    await seasonTeamService.deleteSeasonPlayerFromSeasonTeam(seasonPlayer.seasonTeamId, seasonPlayerId);

    // Delete season player id from the matches he has played
    MatchService matchService = MatchService(databaseReference);
    seasonPlayer.matchesIds.forEach((id) async {
      await matchService.deleteSeasonPlayerFromMatch(id, seasonPlayerId);
    });

    await super.deleteItem(seasonPlayerId);
  }

  /// Delete a match's id from the season player's matchesIds list
  Future<void> deleteMatchFromSeasonPlayer(String seasonPlayerId, String matchId) async {
    SeasonPlayer seasonPlayer = await getItemById(seasonPlayerId);
    seasonPlayer.matchesIds.removeWhere((id) => id == matchId);
    await super.saveItem(seasonPlayer);
  }


}