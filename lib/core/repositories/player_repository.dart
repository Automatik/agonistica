import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class PlayerRepository extends CrudRepository<Player> {

  PlayerRepository(DatabaseReference databaseReference)
    : super(databaseReference, DatabaseService.firebasePlayersChild);

  @override
  Map<String, dynamic> itemToJson(Player t) {
    return t.toJson();
  }

  @override
  Player jsonToItem(Map<dynamic, dynamic> json) {
    return Player.fromJson(json);
  }

  @override
  String getItemId(Player item) {
    return item.id;
  }

}