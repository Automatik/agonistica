import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/Team.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class TeamRepository {

  DatabaseReference _databaseReference;
  String _firebaseTeamsChild;

  static Logger _logger = getLogger('TeamService');

  TeamRepository(DatabaseReference databaseReference) {
    this._databaseReference = databaseReference;
    _firebaseTeamsChild = DatabaseService.firebaseTeamsChild;
  }

  // SET

  /// Upload Team data (insert)
  Future<bool> saveTeam(Team team) async {
    // check if the team exists already by using its id
    Team oldTeam = await getTeamById(team.id);
    if(oldTeam == null) {
      // if the is not found, check first if the team's name is unique, so that
      // no other team is stored with the same name
      bool isNameUnique = await isTeamNameUnique(team.name);
      if(!isNameUnique)
        return false;
    }
    // if it exists or the name is unique just insert or update the team
    await _databaseReference.child(_firebaseTeamsChild).child(team.id).set(team.toJson());
    return true;
  }

  // CHECK

  Future<bool> teamExists(String teamId) async {
    final DataSnapshot snapshot = await _databaseReference.child(_firebaseTeamsChild).child(teamId).once();
    return snapshot.value != null;
  }

  // GET

  /// Download Team data given its id
  Future<Team> getTeamById(String teamId) async {
    final DataSnapshot snapshot = await _databaseReference.child(_firebaseTeamsChild).child(teamId).once();
    Team team;
    if(snapshot.value != null) {
      team = Team.fromJson(snapshot.value);
    }
    return team;
  }

  /// Download Team data given its name and searching only across the team whose id is given
  Future<Team> getTeamByNameFromIds(String teamName, List<String> teamsIds) async {
    bool teamFound = false;
    Team team;
    int i = 0;
    while(i < teamsIds.length && !teamFound) {
      team = await getTeamById(teamsIds[i]);
      if(team.name == teamName)
        teamFound = true;
    }
    return team;
  }

  /// Get List of the requested Teams
  Future<List<Team>> getTeamsByIds(List<String> teamsIds) async {
    List<Team> teams = List();
    for(String teamId in teamsIds) {
      final snapshot = await _databaseReference.child(_firebaseTeamsChild).child(teamId).once();
      final teamValue = snapshot.value;
      if(teamValue != null)
        teams.add(Team.fromJson(teamValue));
    }
    return teams;
  }

  /// Download all teams stores excluding the teams that are referred by the given ids
  Future<List<Team>> getTeamsWithoutIds(List<String> teamsIds) async {
    List<Team> allTeams = await getTeams();
    allTeams.removeWhere((team) => teamsIds.contains(team.id));
    return allTeams;
  }

  /// Download all teams in firebase
  Future<List<Team>> getTeams() async {
    DatabaseReference teamsDatabaseReference = _databaseReference.child(_firebaseTeamsChild);
    final DataSnapshot snapshot = await teamsDatabaseReference.once();
    List<Team> teams = [];
    Map<dynamic, dynamic> values = snapshot.value;
    if(values != null)
      values.forEach((key, value) => teams.add(Team.fromJson(value)));
    return teams;
  }



  // UTILS

  /// Return true if the team name given is unique across all teams stored
  Future<bool> isTeamNameUnique(String newTeamName) async {
    List<Team> teams = await getTeams();
    bool teamNameFound = false;
    int i = 0;
    while(i < teams.length && !teamNameFound) {
      if(teams[i].name == newTeamName)
        teamNameFound = true;
    }
    return !teamNameFound;
  }

}