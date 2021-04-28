import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/player_match_notes.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/repositories/player_notes_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/services/season_player_service.dart';
import 'package:firebase_database/firebase_database.dart';

class PlayerNotesService extends CrudService<PlayerMatchNotes> {

  PlayerNotesService(DatabaseReference databaseReference)
    : super(databaseReference, PlayerNotesRepository(databaseReference, locator<AppStateService>().selectedAppUser.id));

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

  Future<PlayerMatchNotes> getPlayerMatchNotesByPlayer(String seasonPlayerId, String matchId) async {
    // Get SeasonPlayer
    SeasonPlayerService seasonPlayerService = SeasonPlayerService(databaseReference);
    SeasonPlayer seasonPlayer = await seasonPlayerService.getItemById(seasonPlayerId);

    // Get season player's notes
    List<PlayerMatchNotes> playerMatchNotes = await getPlayerNotesByPlayer(seasonPlayer);

    // Find the notes corresponding to the given match
    PlayerMatchNotes notes = findPlayerMatchNoteIdOfMatchFromNotes(playerMatchNotes, matchId);
    return notes;
  }

  Future<String> findPlayerMatchNoteIdOfMatchFromIds(List<String> playerMatchNotesIds, String matchId) async {
    List<PlayerMatchNotes> playerMatchNotes = await getItemsByIds(playerMatchNotesIds);
    PlayerMatchNotes notes = findPlayerMatchNoteIdOfMatchFromNotes(playerMatchNotes, matchId);
    return notes.id;
  }

  PlayerMatchNotes findPlayerMatchNoteIdOfMatchFromNotes(List<PlayerMatchNotes> playerMatchNotes, String matchId) {
    int index = playerMatchNotes.indexWhere((element) => element.matchId == matchId);
    if(index == -1) {
      return null;
    }
    return playerMatchNotes[index];
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