import 'package:agonistica/core/exceptions/not_found_exception.dart';
import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class MatchRepository {

  DatabaseReference _databaseReference;
  String _firebaseMatchesChild;

  static Logger _logger = getLogger('MatchRepository');

  MatchRepository(DatabaseReference databaseReference) {
    this._databaseReference = databaseReference;
    _firebaseMatchesChild = DatabaseService.firebaseMatchesChild;
  }

  // SET

  Future<void> saveMatch(Match match) async {
    Preconditions.requireArgumentNotNull(match.id);

    // it's not necessary to download a full copy of the match object because
    // the match object provided contains already all the data and thus no
    // update is needed
    // (could be different in case of changes to the Match's model)
    await _databaseReference.child(_firebaseMatchesChild).child(match.id).set(match.toJson());
  }

  // GET

  Future<Match> getMatchById(String matchId) async {
    Preconditions.requireArgumentNotNull(matchId);

    final DataSnapshot snapshot = await _databaseReference.child(_firebaseMatchesChild).child(matchId).once();
    Match match;
    if(snapshot.value != null) {
      match = Match.fromJson(snapshot.value);
    }
    return match;
  }

  Future<List<Match>> getMatchesByIds(List<String> matchesIds) async {
    Preconditions.requireArgumentsNotNulls(matchesIds);

    List<Match> matches = List();
    for(String matchId in matchesIds) {
      final snapshot = await _databaseReference.child(_firebaseMatchesChild).child(matchId).once();
      final matchValue = snapshot.value;
      if(matchValue != null)
        matches.add(Match.fromJson(matchValue));
    }
    return matches;
  }

  // DELETE

  Future<void> deleteMatch(String matchId) async {
    Preconditions.requireArgumentNotNull(matchId);

    await _databaseReference.child(_firebaseMatchesChild).child(matchId).remove();
  }

  /// Delete a MatchPlayerData from the given Match.
  /// It doesn't remove the goal scored by the player removed (not enforcing
  /// this constraint)
  Future<void> deletePlayerFromMatch(String matchId, String playerId) async {
    Match match = await getMatchById(matchId);
    if (match == null) {
      throw NotFoundException("Match with id $matchId not found in database.");
    }
    match.playersData.removeWhere((mp) => mp.seasonPlayerId == playerId);
    await saveMatch(match);
  }

}