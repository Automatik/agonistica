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
    await super.saveItem(playerMatchNotes);

    SeasonPlayerService seasonPlayerService = SeasonPlayerService(databaseReference);
    SeasonPlayer seasonPlayer = await seasonPlayerService.getItemById(playerMatchNotes.seasonPlayerId);
    await seasonPlayerService.addPlayerMatchNotesIdToSeasonPlayer(playerMatchNotes.id, seasonPlayer);
  }

  // GET

  /// Download the player's notes
  Future<List<PlayerMatchNotes>> getPlayerNotesByPlayer(SeasonPlayer seasonPlayer) async {
    if(seasonPlayer == null || seasonPlayer.playerMatchNotesIds == null || seasonPlayer.playerMatchNotesIds.isEmpty)
      return Future.value(List<PlayerMatchNotes>());
    List<PlayerMatchNotes> playerMatchNotes = await getItemsByIds(seasonPlayer.playerMatchNotesIds);
    return playerMatchNotes;
  }

  Future<String> findPlayerMatchNoteIdOfMatchFromList(List<String> playerMatchNotesIds, String matchId) async {
    List<PlayerMatchNotes> playerMatchNotes = await getItemsByIds(playerMatchNotesIds);
    int index = playerMatchNotes.indexWhere((element) => element.matchId == matchId);
    if(index == -1) {
      return null;
    }
    return playerMatchNotes[index].id;
  }

  // DELETE

  @override
  Future<void> deleteItem(String playerMatchNotesId) async {
    PlayerMatchNotes playerMatchNotes = await getItemById(playerMatchNotesId);

    SeasonPlayerService seasonPlayerService = SeasonPlayerService(databaseReference);
    SeasonPlayer seasonPlayer = await seasonPlayerService.getItemById(playerMatchNotes.seasonPlayerId);
    await seasonPlayerService.removePlayerMatchNotesIdFromSeasonPlayer(playerMatchNotesId, seasonPlayer);

    await super.deleteItem(playerMatchNotesId);
  }

  Future<void> deletePlayerNotesFromIds(List<String> playerMatchNotesIds) async {
    for(String id in playerMatchNotesIds) {
      await super.deleteItem(id);
    }
  }

}