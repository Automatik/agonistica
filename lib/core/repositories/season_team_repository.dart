import 'package:agonistica/core/exceptions/not_found_exception.dart';
import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class SeasonTeamRepository {

  DatabaseReference _databaseReference;
  String _firebaseSeasonTeamsChild;

  static Logger _logger = getLogger('SeasonTeamRepository');

  SeasonTeamRepository(DatabaseReference databaseReference) {
    this._databaseReference = databaseReference;
    _firebaseSeasonTeamsChild = DatabaseService.firebaseSeasonTeamsChild;
  }

  // SET

  //TODO in databaseService quando salvo un seasonTeam assicurarsi che esista un Team, altrimenti crearlo
  Future<void> saveSeasonTeam(SeasonTeam seasonTeam) async {
    Preconditions.requireArgumentNotEmpty(seasonTeam.id);

    await _databaseReference.child(_firebaseSeasonTeamsChild).child(seasonTeam.id).set(seasonTeam.toJson());
  }

  // GET

  Future<SeasonTeam> getSeasonTeamById(String seasonTeamId) async {
    Preconditions.requireArgumentNotEmpty(seasonTeamId);

    final DataSnapshot snapshot = await _databaseReference.child(_firebaseSeasonTeamsChild).child(seasonTeamId).once();
    SeasonTeam seasonTeam;
    if(snapshot.value != null) {
      seasonTeam = SeasonTeam.fromJson(snapshot.value);
    }
    return seasonTeam;
  }

  Future<List<SeasonTeam>> getSeasonTeamsByIds(List<String> seasonTeamsIds) async {
    Preconditions.requireArgumentsNotNulls(seasonTeamsIds);

    List<SeasonTeam> seasonTeams = List();
    for(String seasonTeamId in seasonTeamsIds) {
      final snapshot = await _databaseReference.child(_firebaseSeasonTeamsChild).child(seasonTeamId).once();
      final seasonTeamValue = snapshot.value;
      if(seasonTeamValue != null)
        seasonTeams.add(SeasonTeam.fromJson(seasonTeamValue));
    }
    return seasonTeams;
  }

  // DELETE

  Future<void> deleteSeasonTeam(String seasonTeamId) async {
    Preconditions.requireArgumentNotEmpty(seasonTeamId);

    await _databaseReference.child(_firebaseSeasonTeamsChild).child(seasonTeamId).remove();
  }

  /// Delete a player id from the team's playerIds list
  Future<void> deleteSeasonPlayerFromSeasonTeam(String seasonTeamId, String seasonPlayerId) async {
    SeasonTeam team = await getSeasonTeamById(seasonTeamId);
    if (team == null) {
      throw NotFoundException("SeasonTeam with id $seasonTeamId not found in database.");
    }
    team.seasonPlayersIds.removeWhere((id) => id == seasonPlayerId);
    await saveSeasonTeam(team);
  }

  /// Delete a match id from the team's matchesIds list
  Future<void> deleteMatchFromSeasonTeam(String seasonTeamId, String matchId) async {
    SeasonTeam team = await getSeasonTeamById(seasonTeamId);
    if (team == null) {
      throw NotFoundException("SeasonTeam with id $seasonTeamId not found in database.");
    }
    team.matchesIds.removeWhere((id) => id == matchId);
    await saveSeasonTeam(team);
  }

}