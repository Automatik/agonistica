import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/match_player_data.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/repositories/match_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/services/season_player_service.dart';
import 'package:agonistica/core/services/season_team_service.dart';
import 'package:firebase_database/firebase_database.dart';

class MatchService extends CrudService<Match> {

  MatchService(DatabaseReference databaseReference)
    : super(databaseReference, MatchRepository(databaseReference));

  // SET

  @override
  Future<void> saveItem(Match match) async {
    bool matchPreviouslySaved = await itemExists(match.id);
    if(matchPreviouslySaved) {
      Match oldMatch = await getItemById(match.id);
      // If a team is changed, remove the match's id from the old team

      await _removeOldTeamFromMatch(oldMatch.seasonTeam1Id, match.seasonTeam1Id, match.id);
      await _removeOldTeamFromMatch(oldMatch.seasonTeam2Id, match.seasonTeam2Id, match.id);

      // Remove the match's id from the players that are no more in the match
      // and also remove the stats regarding this match from the player stats
      await _removeMatchIdAndStatsFromRemovedPlayers(oldMatch.playersData, match.playersData, match.id);
    }

    // Create SeasonTeam and Team objects if they do not exist yet
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    await seasonTeamService.saveSeasonTeamIfNotExists(match.getSeasonTeam1());
    await seasonTeamService.saveSeasonTeamIfNotExists(match.getSeasonTeam2());

    // Create SeasonPlayer and Player objects from those players appearing for the first time in
    // a match, as MatchPlayerData objects, that do not exist yet
    SeasonPlayerService seasonPlayerService = SeasonPlayerService(databaseReference);
    match.playersData.forEach((p) async {
      SeasonPlayer seasonPlayer = p.toSeasonPlayer(match.categoryId, match.seasonId);
      await seasonPlayerService.saveSeasonPlayerIfNotExists(seasonPlayer);
    });

    await super.saveItem(match);

    // Create a new SeasonPlayer and Player object for every new player

    // get players data that is needed to both update the players's matchesIds
    // and teams's playersIds
    List<String> team1MatchPlayerIds = match.playersData.where((p) => p.seasonTeamId == match.seasonTeam1Id).map((p) => p.seasonPlayerId).toList();
    List<String> team2MatchPlayerIds = match.playersData.where((p) => p.seasonTeamId == match.seasonTeam2Id).map((p) => p.seasonPlayerId).toList();
    List<String> matchPlayersIds = List.from(team1MatchPlayerIds);
    matchPlayersIds.addAll(team2MatchPlayerIds);
    List<SeasonPlayer> matchPlayers = await seasonPlayerService.getItemsByIds(matchPlayersIds);

    // Update teams's matchesIds, categoriesIds and playersIds
    await seasonTeamService.updateSeasonTeamFromMatch(match, match.getSeasonTeam1(), team1MatchPlayerIds);
    await seasonTeamService.updateSeasonTeamFromMatch(match, match.getSeasonTeam2(), team2MatchPlayerIds);

    // update players's matchesIds and also implicitly the player's teamId
    for(SeasonPlayer seasonPlayer in matchPlayers) {
      await seasonPlayerService.addMatchIdToSeasonPlayer(match.id, seasonPlayer);
      await _updatePlayerStatsFromMatchPlayerData(seasonPlayer);
      await seasonPlayerService.saveItem(seasonPlayer);
    }
  }

  Future<void> updateMatchPlayersNamesFromSeasonPlayer(SeasonPlayer seasonPlayer) async {
    List<Match> matches = await getItemsByIds(seasonPlayer.matchesIds);
    for(Match match in matches) {
      int index = match.playersData.indexWhere((data) => data.seasonPlayerId == seasonPlayer.id);
      if(index > -1) {
        Player player = seasonPlayer.player;
        match.playersData[index].name = player.name;
        match.playersData[index].surname = player.surname;
        await super.saveItem(match);
      } else {
        CrudService.logger.d("MatchPlayerData not found from player's matchesIds."
            " Shouldn't happen! Player id: ${seasonPlayer.id} Match id: ${match.id}");
      }
    }
  }

  /// Update the player stats based on all the matches he has played.
  /// To avoid counting stats more time the count is done from start every time
  Future<void> _updatePlayerStatsFromMatchPlayerData(SeasonPlayer seasonPlayer) async {
    // Get matches in which the player has played
    List<Match> matches = await getItemsByIds(seasonPlayer.matchesIds);

    List<MatchPlayerData> playerDataList = matches.map((m) => m.playersData.firstWhere((p) => p.seasonPlayerId == seasonPlayer.id)).toList();

    seasonPlayer.resetStats();
    for(MatchPlayerData playerData in playerDataList) {
      seasonPlayer.updateFromMatch(playerData);
    }
  }

  Future<void> _removeOldTeamFromMatch(String oldMatchSeasonTeamId, String currentMatchSeasonTeamId, String matchId) async {
    if(oldMatchSeasonTeamId != currentMatchSeasonTeamId) {
      SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
      SeasonTeam seasonTeam = await seasonTeamService.getItemById(oldMatchSeasonTeamId);
      seasonTeam.removeMatch(matchId);
      await seasonTeamService.saveItem(seasonTeam);
    }
  }

  Future<void> _removeMatchIdAndStatsFromRemovedPlayers(List<MatchPlayerData> oldMatchPlayersData, List<MatchPlayerData> currentMatchPlayerData, String matchId) async {
    // Map MatchPlayerData to a list of players ids
    List<String> oldPlayerIds = oldMatchPlayersData.map((p) => p.seasonPlayerId).toList();
    List<String> currentPlayerIds = currentMatchPlayerData.map((p) => p.seasonPlayerId).toList();
    // Keep in oldPlayerIds only the players that are now removed from the Match
    oldPlayerIds.retainWhere((op) => !currentPlayerIds.contains(op));
    // Do the same for the list of MatchPlayerData
    oldMatchPlayersData.retainWhere((mpd) => oldPlayerIds.contains(mpd.seasonPlayerId));
    // Update SeasonPlayer objects
    SeasonPlayerService seasonPlayerService = SeasonPlayerService(databaseReference);
    List<SeasonPlayer> seasonPlayers = await seasonPlayerService.getItemsByIds(oldPlayerIds);
    for(SeasonPlayer seasonPlayer in seasonPlayers) {
      // Remove this match id from the matchesIds of the removed player
      seasonPlayer.removeMatch(matchId);
      // Update the player stats (remove this match from the matches count and eventually goals and cards)
      await _updatePlayerStatsFromMatchPlayerData(seasonPlayer);
      await seasonPlayerService.saveItem(seasonPlayer);
    }
  }

  // GET

  /// Download all the matches of a team by filtering for the given category
  Future<List<Match>> getTeamMatchesByCategory(SeasonTeam seasonTeam, Category category) async {
    if(seasonTeam == null || seasonTeam.categoriesIds == null || seasonTeam.categoriesIds.isEmpty ||
        seasonTeam.matchesIds == null || seasonTeam.matchesIds.isEmpty || category == null)
      return Future.value(List<Match>());
    List<Match> matches = await getItemsByIds(seasonTeam.matchesIds);
    matches.removeWhere((match) => match.categoryId != category.id);
    return matches;
  }

  /// Download missing info for a given list of matches. For instance download the teams' names
  /// present in the matches list
  Future<List<Match>> completeMatchesWithMissingInfo(List<Match> matches) async {
    List<Match> newMatches = [];
    for(Match match in matches) {
      // Get teams' names
      SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
      SeasonTeam seasonTeam1 = await seasonTeamService.getFullSeasonTeamById(match.seasonTeam1Id);
      SeasonTeam seasonTeam2 = await seasonTeamService.getFullSeasonTeamById(match.seasonTeam2Id);
      match.team1 = seasonTeam1.team;
      match.team2 = seasonTeam2.team;
      newMatches.add(match);
    }
    return newMatches;
  }

  // DELETE

  @override
  Future<void> deleteItem(String matchId) async {
    Match match = await getItemById(matchId);

    // Delete match id from teams
    String seasonTeam1Id = match.seasonTeam1Id;
    String seasonTeam2Id = match.seasonTeam2Id;
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    SeasonTeam seasonTeam1 = await seasonTeamService.getItemById(seasonTeam1Id);
    SeasonTeam seasonTeam2 = await seasonTeamService.getItemById(seasonTeam2Id);
    await seasonTeamService.deleteMatchFromSeasonTeam(seasonTeam1, matchId);
    await seasonTeamService.deleteMatchFromSeasonTeam(seasonTeam2, matchId);

    // Delete match id from players
    SeasonPlayerService seasonPlayerService = SeasonPlayerService(databaseReference);
    match.playersData.map((p) => p.seasonPlayerId).forEach((id) async {
      SeasonPlayer seasonPlayer = await seasonPlayerService.getItemById(id);
      await seasonPlayerService.deleteMatchFromSeasonPlayer(seasonPlayer, matchId);
    });

    // Delete match
    await super.deleteItem(matchId);
  }

  Future<void> deleteMatchesFromIds(List<String> matchesIds) async {
    matchesIds.forEach((id) async {
      await super.deleteItem(id);
    });
  }

  Future<void> deleteSeasonPlayerFromMatchesIds(List<Match> matches, String seasonPlayerId) async {
    matches.forEach((match) async {
      await deleteSeasonPlayerFromMatch(match, seasonPlayerId);
    });
  }

  /// Delete a MatchPlayerData from the given Match.
  /// It doesn't remove the goal scored by the player removed (not enforcing
  /// this constraint)
  Future<void> deleteSeasonPlayerFromMatch(Match match, String seasonPlayerId) async {
    match.playersData.removeWhere((mp) => mp.seasonPlayerId == seasonPlayerId);
    await super.saveItem(match);
  }

}