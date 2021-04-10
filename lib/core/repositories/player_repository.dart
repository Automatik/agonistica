import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/player.dart';
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
    Preconditions.requireArgumentNotEmpty(player.id);

    await _databaseReference.child(_firebasePlayersChild).child(player.id).set(player.toJson());
  }

  // GET

  Future<Player> getPlayerById(String playerId) async {
    Preconditions.requireArgumentNotEmpty(playerId);

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
    Preconditions.requireArgumentNotEmpty(playerId);

    await _databaseReference.child(_firebasePlayersChild).child(playerId).remove();
  }

}