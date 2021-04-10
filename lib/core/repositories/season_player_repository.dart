import 'package:agonistica/core/exceptions/not_found_exception.dart';
import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class SeasonPlayerRepository {

  DatabaseReference _databaseReference;
  String _firebaseSeasonPlayersChild;

  static Logger _logger = getLogger('SeasonPlayerRepository');

  SeasonPlayerRepository(DatabaseReference databaseReference) {
    this._databaseReference = databaseReference;
    _firebaseSeasonPlayersChild = DatabaseService.firebaseSeasonPlayersChild;
  }

  // SET

  //TODO in databaseService quando salvo un seasonPlayer assicurarsi che esista un Player, altrimenti crearlo
  Future<void> saveSeasonPlayer(SeasonPlayer seasonPlayer) async {
    Preconditions.requireArgumentNotEmpty(seasonPlayer.id);

    await _databaseReference.child(_firebaseSeasonPlayersChild).child(seasonPlayer.id).set(seasonPlayer.toJson());
  }

  // GET

  Future<SeasonPlayer> getSeasonPlayerById(String seasonPlayerId) async {
    Preconditions.requireArgumentNotEmpty(seasonPlayerId);

    final DataSnapshot snapshot = await _databaseReference.child(_firebaseSeasonPlayersChild).child(seasonPlayerId).once();
    SeasonPlayer seasonPlayer;
    if(snapshot.value != null) {
      seasonPlayer = SeasonPlayer.fromJson(snapshot.value);
    }
    return seasonPlayer;
  }

  Future<List<SeasonPlayer>> getSeasonPlayersByIds(List<String> seasonPlayersIds) async {
    Preconditions.requireArgumentsNotNulls(seasonPlayersIds);

    List<SeasonPlayer> seasonPlayers = List();
    for(String seasonPlayerId in seasonPlayersIds) {
      final snapshot = await _databaseReference.child(_firebaseSeasonPlayersChild).child(seasonPlayerId).once();
      final seasonPlayerValue = snapshot.value;
      if(seasonPlayerValue != null)
        seasonPlayers.add(SeasonPlayer.fromJson(seasonPlayerValue));
    }
    return seasonPlayers;
  }

  // DELETE

  Future<void> deleteSeasonPlayer(String seasonPlayerId) async {
    Preconditions.requireArgumentNotEmpty(seasonPlayerId);

    await _databaseReference.child(_firebaseSeasonPlayersChild).child(seasonPlayerId).remove();
  }

  /// Delete a match's id from the season player's matchesIds list
  Future<void> deleteMatchFromSeasonPlayer(String seasonPlayerId, String matchId) async {
    SeasonPlayer seasonPlayer = await getSeasonPlayerById(seasonPlayerId);
    if (seasonPlayer == null) {
      throw NotFoundException("SeasonPlayer with id $seasonPlayerId not found in database.");
    }
    seasonPlayer.matchesIds.removeWhere((id) => id == matchId);
    await saveSeasonPlayer(seasonPlayer);
  }

}