import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class SeasonTeamRepository extends CrudRepository<SeasonTeam> {

  SeasonTeamRepository(DatabaseReference databaseReference)
    : super(databaseReference, DatabaseService.firebaseSeasonTeamsChild);

  // SET

  //TODO in databaseService quando salvo un seasonTeam assicurarsi che esista un Team, altrimenti crearlo
  Future<void> saveSeasonTeam(SeasonTeam seasonTeam) async {
    await super.saveItem(seasonTeam.id, seasonTeam);
  }

  // GET

  Future<SeasonTeam> getSeasonTeamById(String seasonTeamId) async {
    return await super.getItemById(seasonTeamId);
  }

  Future<List<SeasonTeam>> getSeasonTeamsByIds(List<String> seasonTeamsIds) async {
    return await super.getItemsByIds(seasonTeamsIds);
  }

  // DELETE

  Future<void> deleteSeasonTeam(String seasonTeamId) async {
    await super.deleteItem(seasonTeamId);
  }

  /// Delete a player id from the team's playerIds list
  Future<void> deleteSeasonPlayerFromSeasonTeam(String seasonTeamId, String seasonPlayerId) async {
    SeasonTeam team = await getSeasonTeamById(seasonTeamId);
    team.seasonPlayersIds.removeWhere((id) => id == seasonPlayerId);
    await saveSeasonTeam(team);
  }

  /// Delete a match id from the team's matchesIds list
  Future<void> deleteMatchFromSeasonTeam(String seasonTeamId, String matchId) async {
    SeasonTeam team = await getSeasonTeamById(seasonTeamId);
    team.matchesIds.removeWhere((id) => id == matchId);
    await saveSeasonTeam(team);
  }

  @override
  Map<String, dynamic> itemToJson(SeasonTeam t) {
    return t.toJson();
  }

  @override
  SeasonTeam jsonToItem(Map<dynamic, dynamic> json) {
    return SeasonTeam.fromJson(json);
  }

}