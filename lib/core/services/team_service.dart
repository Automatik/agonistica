import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/repositories/team_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:firebase_database/firebase_database.dart';

class TeamService extends CrudService<Team> {

  TeamService(DatabaseReference databaseReference)
    : super(databaseReference, TeamRepository(databaseReference));

  /// Download Team data given its name and searching only across the team whose id is given
  Future<Team> getTeamByNameFromIds(String teamName, List<String> teamsIds) async {
    bool teamFound = false;
    Team team;
    int i = 0;
    while(i < teamsIds.length && !teamFound) {
      team = await getItemById(teamsIds[i]);
      if(team.name == teamName)
        teamFound = true;
    }
    return team;
  }

}