import 'package:agonistica/core/exceptions/not_found_exception.dart';
import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/Player.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class PlayerRepository {

  DatabaseReference _databaseReference;
  String _firebasePlayersChild;

  static Logger _logger = getLogger('PlayerRepository');

  PlayerRepository(DatabaseReference databaseReference) {
    this._databaseReference = databaseReference;
    _firebasePlayersChild = DatabaseService.firebasePlayersChild;
  }

  // SET

  Future<void> savePlayer(Player player) async {
    Preconditions.requireArgumentNotNull(player.id);

    await _databaseReference.child(_firebasePlayersChild).child(player.id).set(player.toJson());
  }

  // GET

  Future<Player> getPlayerById(String playerId) async {
    Preconditions.requireArgumentNotNull(playerId);

    final DataSnapshot snapshot = await _databaseReference.child(_firebasePlayersChild).child(playerId).once();
    Player player;
    if(snapshot.value != null) {
      player = Player.fromJson(snapshot.value);
    }
    return player;
  }

  Future<List<Player>> getPlayersByIds(List<String> playersIds) async {
    Preconditions.requireArgumentsNotNulls(playersIds);

    List<Player> players = List();
    for(String playerId in playersIds) {
      final snapshot = await _databaseReference.child(_firebasePlayersChild).child(playerId).once();
      final playerValue = snapshot.value;
      if(playerValue != null)
        players.add(Player.fromJson(playerValue));
    }
    return players;
  }

  // DELETE

  Future<void> deletePlayer(String playerId) async {
    Preconditions.requireArgumentNotNull(playerId);

    await _databaseReference.child(_firebasePlayersChild).child(playerId).remove();
  }

  /// Delete a match's id from the player's matchesIds list
  Future<void> deleteMatchFromPlayer(String playerId, String matchId) async {
    Player player = await getPlayerById(playerId);
    if (player == null) {
      throw NotFoundException("Player with id $playerId not found in database.");
    }
    player.matchesIds.removeWhere((id) => id == matchId);
    await savePlayer(player);
  }

}