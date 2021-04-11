import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class TeamRepository extends CrudRepository<Team> {

  TeamRepository(DatabaseReference databaseReference)
    : super(databaseReference, DatabaseService.firebaseTeamsChild);

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
    await super.saveItem(team);
    return true;
  }

  // CHECK

  Future<bool> teamExists(String teamId) async {
    return await super.itemExists(teamId);
  }

  // GET

  /// Download Team data given its id
  Future<Team> getTeamById(String teamId) async {
    return await super.getItemById(teamId);
  }

  /// Download Team data given its name and searching only across the team whose id is given
  Future<Team> getTeamByNameFromIds(String teamName, List<String> teamsIds) async {
    Preconditions.requireArgumentsNotNulls(teamsIds);

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
    return await super.getItemsByIds(teamsIds);
  }

  /// Download all teams stores excluding the teams that are referred by the given ids
  Future<List<Team>> getTeamsWithoutIds(List<String> teamsIds) async {
    Preconditions.requireArgumentsNotNulls(teamsIds);

    List<Team> allTeams = await getTeams();
    allTeams.removeWhere((team) => teamsIds.contains(team.id));
    return allTeams;
  }

  /// Download all teams in firebase
  Future<List<Team>> getTeams() async {
    return await super.getAllItems();
  }

  // UTILS

  /// Return true if the team name given is unique across all teams stored
  Future<bool> isTeamNameUnique(String newTeamName) async {
    Preconditions.requireArgumentNotEmpty(newTeamName);

    List<Team> teams = await getTeams();
    bool teamNameFound = false;
    int i = 0;
    while(i < teams.length && !teamNameFound) {
      if(teams[i].name == newTeamName) {
        teamNameFound = true;
      }
      i++;
    }
    return !teamNameFound;
  }

  @override
  Map<String, dynamic> itemToJson(Team t) {
    return t.toJson();
  }

  @override
  Team jsonToItem(Map<dynamic, dynamic> json) {
    return Team.fromJson(json);
  }

  @override
  String getItemId(Team item) {
    return item.id;
  }

}