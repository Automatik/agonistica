import 'package:agonistica/core/exceptions/not_found_exception.dart';
import 'package:agonistica/core/models/season.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/repositories/season_team_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/services/match_service.dart';
import 'package:agonistica/core/services/season_player_service.dart';
import 'package:agonistica/core/services/season_service.dart';
import 'package:agonistica/core/services/team_service.dart';
import 'package:firebase_database/firebase_database.dart';

class SeasonTeamService extends CrudService<SeasonTeam> {

  SeasonTeamService(DatabaseReference databaseReference)
    : super(databaseReference, SeasonTeamRepository(databaseReference));

  // SET

  @override
  Future<void> saveItem(SeasonTeam seasonTeam) async {
    // Before creating a seasonTeam be sure that a Team exists

    // if team does not exist
    TeamService teamService = TeamService(databaseReference);
    await teamService.createTeamFromSeasonTeam(seasonTeam);

    // if team does already exist, add seasonTeamId to the list
    await teamService.addSeasonTeamToTeam(seasonTeam.id, seasonTeam.teamId);

    await super.saveItem(seasonTeam);
  }

  Future<void> saveSeasonTeamIfNotExists(SeasonTeam seasonTeam) async {
    bool seasonTeamExists = await itemExists(seasonTeam.id);
    if(!seasonTeamExists) {
      await saveItem(seasonTeam);
    }
  }

  /// Upload Team data (update)
  Future<void> updateSeasonTeamFromMatch(Match match, SeasonTeam seasonTeam, List<String> matchSeasonPlayersIds) async {
    SeasonTeam latestVersion = await getItemById(seasonTeam.id);
    seasonTeam = latestVersion;
    // update the categories in which the team appears
    seasonTeam.addCategory(match.categoryId);
    // update the matches in which the team plays
    seasonTeam.addMatch(match.id);
    // update the team's players
    for(String seasonPlayerId in matchSeasonPlayersIds) {
      seasonTeam.addSeasonPlayer(seasonPlayerId);
    }

    await super.saveItem(seasonTeam);
  }

  /// Update the SeasonTeam seasonPlayersIds
  Future<SeasonTeam> addSeasonPlayerToSeasonTeam(String seasonTeamId, String seasonPlayerId) async {
    SeasonTeam seasonTeam = await getItemById(seasonTeamId);
    seasonTeam.addSeasonPlayer(seasonPlayerId);
    await super.saveItem(seasonTeam);
    return seasonTeam;
  }

  // GET

  Future<SeasonTeam> getFullSeasonTeamById(String seasonTeamId) async {
    SeasonTeam seasonTeam = await getItemById(seasonTeamId);
    return completeSeasonTeamWithMissingInfo(seasonTeam);
  }

  Future<SeasonTeam> completeSeasonTeamWithMissingInfo(SeasonTeam seasonTeam) async {
    TeamService teamService = TeamService(databaseReference);
    Team team = await teamService.getItemById(seasonTeam.teamId);
    seasonTeam.team = team;
    return seasonTeam;
  }

  Future<SeasonTeam> getCurrentSeasonTeamFromIds(List<String> seasonTeamsIds) async {
    SeasonService seasonService = SeasonService(databaseReference);
    Season currentSeason = await seasonService.getCurrentSeason();
    List<SeasonTeam> seasonTeams = await getItemsByIds(seasonTeamsIds);
    int index = seasonTeams.indexWhere((st) => st.seasonId == currentSeason.id);
    if(index == -1) {
      throw NotFoundException("No seasonTeam found in those provided belonging to the current season");
    }
    return seasonTeams[index];
  }

  /// Get all the season teams in the current season.
  Future<List<SeasonTeam>> getCurrentSeasonTeams() async {
    SeasonService seasonService = SeasonService(databaseReference);
    Season currentSeason = await seasonService.getCurrentSeason();
    return await getSeasonTeamsWithSeason(currentSeason.id);
  }

  Future<List<SeasonTeam>> getSeasonTeamsWithSeason(String seasonId) async {
    List<SeasonTeam> seasonTeams = await getAllItems();
    // keep only seasonTeams within current season
    seasonTeams.retainWhere((st) => st.seasonId == seasonId);
    return seasonTeams;
  }

  /// Download all teams stores excluding the teams that are referred by the given ids
  Future<List<SeasonTeam>> getTeamsWithoutIds(List<String> seasonTeamsIds) async {
    List<SeasonTeam> allTeams = await getAllItems();
    allTeams.removeWhere((team) => seasonTeamsIds.contains(team.id));
    return allTeams;
  }

  // DELETE

  @override
  Future<void> deleteItem(String seasonTeamId) async {
    SeasonTeam seasonTeam = await getItemById(seasonTeamId);

    // Delete season team id from team
    TeamService teamService = TeamService(databaseReference);
    await teamService.deleteSeasonTeamFromTeam(seasonTeamId, seasonTeam.teamId);

    // Delete season players that belong to this season team
    SeasonPlayerService seasonPlayerService = SeasonPlayerService(databaseReference);
    await seasonPlayerService.deleteSeasonPlayersByIds(seasonTeam.seasonPlayersIds);

    // Delete matches the team has played
    MatchService matchService = MatchService(databaseReference);
    await matchService.deleteMatchesFromIds(seasonTeam.matchesIds);

    await super.deleteItem(seasonTeamId);
  }

  /// Delete a player id from the team's playerIds list
  Future<SeasonTeam> deleteSeasonPlayerFromSeasonTeam(String seasonTeamId, String seasonPlayerId) async {
    SeasonTeam seasonTeam = await getItemById(seasonTeamId);
    seasonTeam.removeSeasonPlayer(seasonPlayerId);
    await super.saveItem(seasonTeam);
    return seasonTeam;
  }

  /// Delete a match id from the team's matchesIds list
  Future<SeasonTeam> deleteMatchFromSeasonTeam(String seasonTeamId, String matchId) async {
    SeasonTeam seasonTeam = await getItemById(seasonTeamId);
    seasonTeam.removeMatch(matchId);
    await super.saveItem(seasonTeam);
    return seasonTeam;
  }

}