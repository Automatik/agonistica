import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class PlayerRepository extends CrudRepository<Player> {

  PlayerRepository(DatabaseReference databaseReference)
    : super(databaseReference, DatabaseService.firebasePlayersChild);

  // SET

  Future<void> savePlayer(Player player) async {
    await super.saveItem(player.id, player);
  }

  // GET

  Future<Player> getPlayerById(String playerId) async {
    return await super.getItemById(playerId);
  }

  Future<List<Player>> getPlayersByIds(List<String> playersIds) async {
    return await super.getItemsByIds(playersIds);
  }

  // DELETE

  Future<void> deletePlayer(String playerId) async {
    await super.deleteItem(playerId);
  }

  @override
  Map<String, dynamic> itemToJson(Player t) {
    return t.toJson();
  }

  @override
  Player jsonToItem(Map<dynamic, dynamic> json) {
    return Player.fromJson(json);
  }

}