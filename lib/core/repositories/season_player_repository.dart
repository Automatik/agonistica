import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class SeasonPlayerRepository extends CrudRepository<SeasonPlayer> {

  SeasonPlayerRepository(DatabaseReference databaseReference)
    : super(databaseReference, DatabaseService.firebaseSeasonPlayersChild);

  // SET

  //TODO in databaseService quando salvo un seasonPlayer assicurarsi che esista un Player, altrimenti crearlo
  Future<void> saveSeasonPlayer(SeasonPlayer seasonPlayer) async {
    await super.saveItem(seasonPlayer);
  }

  // GET

  Future<SeasonPlayer> getSeasonPlayerById(String seasonPlayerId) async {
    return await super.getItemById(seasonPlayerId);
  }

  Future<List<SeasonPlayer>> getSeasonPlayersByIds(List<String> seasonPlayersIds) async {
    return await super.getItemsByIds(seasonPlayersIds);
  }

  // DELETE

  Future<void> deleteSeasonPlayer(String seasonPlayerId) async {
    await super.deleteItem(seasonPlayerId);
  }

  /// Delete a match's id from the season player's matchesIds list
  Future<void> deleteMatchFromSeasonPlayer(String seasonPlayerId, String matchId) async {
    SeasonPlayer seasonPlayer = await getSeasonPlayerById(seasonPlayerId);
    seasonPlayer.matchesIds.removeWhere((id) => id == matchId);
    await saveSeasonPlayer(seasonPlayer);
  }

  @override
  Map<String, dynamic> itemToJson(SeasonPlayer t) {
    return t.toJson();
  }

  @override
  SeasonPlayer jsonToItem(Map<dynamic, dynamic> json) {
    return SeasonPlayer.fromJson(json);
  }

  @override
  String getItemId(SeasonPlayer item) {
    return item.id;
  }

}