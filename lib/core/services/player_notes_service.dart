import 'package:agonistica/core/models/player_match_notes.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/repositories/player_notes_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/services/season_player_service.dart';
import 'package:firebase_database/firebase_database.dart';

class PlayerNotesService extends CrudService<PlayerMatchNotes> {

  PlayerNotesService(DatabaseReference databaseReference)
    : super(databaseReference, PlayerNotesRepository(databaseReference));

  // SET

  @override
  Future<void> saveItem(PlayerMatchNotes playerMatchNotes) async {
    SeasonPlayerService seasonPlayerService = SeasonPlayerService(databaseReference);
    SeasonPlayer seasonPlayer = await seasonPlayerService.getItemById(playerMatchNotes.seasonPlayerId);

    await super.saveItem(playerMatchNotes);

    // update player's playerMatchNodesIds
    if(seasonPlayer.playerMatchNotesIds == null)
      seasonPlayer.playerMatchNotesIds = [];
    if(!seasonPlayer.playerMatchNotesIds.contains(playerMatchNotes.id)) {
      seasonPlayer.playerMatchNotesIds.add(playerMatchNotes.id);
      await seasonPlayerService.saveItem(seasonPlayer);
    }
  }

  // GET

  /// Download the player's notes
  Future<List<PlayerMatchNotes>> getPlayerNotesByPlayer(SeasonPlayer seasonPlayer) async {
    if(seasonPlayer == null || seasonPlayer.playerMatchNotesIds == null || seasonPlayer.playerMatchNotesIds.isEmpty)
      return Future.value(List<PlayerMatchNotes>());
    List<PlayerMatchNotes> playerMatchNotes = await getItemsByIds(seasonPlayer.playerMatchNotesIds);
    return playerMatchNotes;
  }

}