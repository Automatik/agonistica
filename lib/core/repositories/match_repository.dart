import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/Match.dart';
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
    Preconditions.requireNotNull(match.id);

    // it's not necessary to download a full copy of the match object because
    // the match object provided contains already all the data and thus no
    // update is needed
    // (could be different in case of changes to the Match's model)
    await _databaseReference.child(_firebaseMatchesChild).child(match.id).set(match.toJson());
  }

  // GET

  Future<Match> getMatchById(String matchId) async {
    Preconditions.requireNotNull(matchId);

    final DataSnapshot snapshot = await _databaseReference.child(_firebaseMatchesChild).child(matchId).once();
    Match match;
    if(snapshot.value != null) {
      match = Match.fromJson(snapshot.value);
    }
    return match;
  }

  Future<List<Match>> getMatchesByIds(List<String> matchesIds) async {
    Preconditions.requireNotNulls(matchesIds);

    List<Match> matches = List();
    for(String matchId in matchesIds) {
      final snapshot = await _databaseReference.child(_firebaseMatchesChild).child(matchId).once();
      final matchValue = snapshot.value;
      if(matchValue != null)
        matches.add(Match.fromJson(matchValue));
    }
    return matches;
  }

}