import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class MatchRepository extends CrudRepository<Match> {

  MatchRepository(DatabaseReference databaseReference)
    : super(databaseReference, DatabaseService.firebaseMatchesChild);

  // SET

  // it's not necessary to download a full copy of the match object because
  // the match object provided contains already all the data and thus no
  // update is needed
  // (could be different in case of changes to the Match's model)
  Future<void> saveMatch(Match match) async {
    await super.saveItem(match.id, match);
  }

  // GET

  Future<Match> getMatchById(String matchId) async {
    return await super.getItemById(matchId);
  }

  Future<List<Match>> getMatchesByIds(List<String> matchesIds) async {
    return await super.getItemsByIds(matchesIds);
  }

  // DELETE

  Future<void> deleteMatch(String matchId) async {
    await super.deleteItem(matchId);
  }

  /// Delete a MatchPlayerData from the given Match.
  /// It doesn't remove the goal scored by the player removed (not enforcing
  /// this constraint)
  Future<void> deletePlayerFromMatch(String matchId, String playerId) async {
    Match match = await getMatchById(matchId);
    match.playersData.removeWhere((mp) => mp.seasonPlayerId == playerId);
    await saveMatch(match);
  }

  @override
  Map<String, dynamic> itemToJson(Match t) {
    return t.toJson();
  }

  @override
  Match jsonToItem(Map<dynamic, dynamic> json) {
    return Match.fromJson(json);
  }

}