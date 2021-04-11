import 'package:agonistica/core/models/player_match_notes.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class PlayerNotesRepository extends CrudRepository<PlayerMatchNotes> {

  PlayerNotesRepository(DatabaseReference databaseReference)
    : super(databaseReference, DatabaseService.firebasePlayersNotesChild);

  // SET

  Future<void> savePlayerMatchNotes(PlayerMatchNotes playerMatchNotes) async {
    await super.saveItem(playerMatchNotes);
  }

  // GET

  Future<PlayerMatchNotes> getPlayerNotesById(String playerNotesId) async {
    return await super.getItemById(playerNotesId);
  }

  Future<List<PlayerMatchNotes>> getPlayersNotesByIds(List<String> playersMatchNotesIds) async {
    return await super.getItemsByIds(playersMatchNotesIds);
  }

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