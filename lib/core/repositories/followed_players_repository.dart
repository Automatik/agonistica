import 'package:agonistica/core/models/followed_players.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class FollowedPlayersRepository extends CrudRepository<FollowedPlayers> {

  FollowedPlayersRepository(DatabaseReference databaseReference, String firebaseUserId)
      : super(databaseReference, DatabaseService.firebaseFollowedPlayersChild, firebaseUserId: firebaseUserId);

  @override
  Map<String, dynamic> itemToJson(FollowedPlayers t) {
    return t.toJson();
  }

  @override
  FollowedPlayers jsonToItem(Map<dynamic, dynamic> json) {
    return FollowedPlayers.fromJson(json);
  }

  @override
  String getItemId(FollowedPlayers item) {
    return item.id;
  }

}