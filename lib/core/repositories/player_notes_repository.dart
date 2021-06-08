// @dart=2.9

import 'package:agonistica/core/models/player_match_notes.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class PlayerNotesRepository extends CrudRepository<PlayerMatchNotes> {

  PlayerNotesRepository(DatabaseReference databaseReference, String firebaseUserId)
    : super(databaseReference, DatabaseService.firebasePlayersNotesChild, firebaseUserId: firebaseUserId);

  @override
  Map<String, dynamic> itemToJson(PlayerMatchNotes t) {
    return t.toJson();
  }

  @override
  PlayerMatchNotes jsonToItem(Map<dynamic, dynamic> json) {
    return PlayerMatchNotes.fromJson(json);
  }

  @override
  String getItemId(PlayerMatchNotes item) {
    return item.id;
  }

}