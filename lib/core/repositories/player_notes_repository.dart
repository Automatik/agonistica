import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/models/PlayerMatchNotes.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class PlayerNotesRepository {

  DatabaseReference _databaseReference;
  String _firebasePlayersNotesChild;

  PlayerNotesRepository(DatabaseReference databaseReference) {
    this._databaseReference = databaseReference;
    _firebasePlayersNotesChild = DatabaseService.firebasePlayersNotesChild;
  }

  // SET

  Future<void> savePlayerMatchNotes(PlayerMatchNotes playerMatchNotes) async {
    Preconditions.requireArgumentNotNull(playerMatchNotes.id);

    await _databaseReference.child(_firebasePlayersNotesChild).child(playerMatchNotes.id).set(playerMatchNotes.toJson());
  }

  // GET

  Future<PlayerMatchNotes> getPlayerNotesById(String playerNotesId) async {
    Preconditions.requireArgumentNotNull(playerNotesId);

    final DataSnapshot snapshot = await _databaseReference.child(_firebasePlayersNotesChild).child(playerNotesId).once();
    PlayerMatchNotes playerMatchNotes;
    if(snapshot.value != null) {
      playerMatchNotes = PlayerMatchNotes.fromJson(snapshot.value);
    }
    return playerMatchNotes;
  }

  Future<List<PlayerMatchNotes>> getPlayersNotesByIds(List<String> playersMatchNotesIds) async {
    Preconditions.requireArgumentsNotNulls(playersMatchNotesIds);

    List<PlayerMatchNotes> playersMatchNotes = List();
    for(String playerMatchNotesId in playersMatchNotesIds) {
      final snapshot = await _databaseReference.child(_firebasePlayersNotesChild).child(playerMatchNotesId).once();
      final playerMatchNotesValue = snapshot.value;
      if(playerMatchNotesValue != null)
        playersMatchNotes.add(PlayerMatchNotes.fromJson(playerMatchNotesValue));
    }
    return playersMatchNotes;
  }

}