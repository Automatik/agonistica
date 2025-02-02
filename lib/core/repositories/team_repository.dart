import 'package:agonistica/core/exceptions/integrity_exception.dart';
import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class TeamRepository extends CrudRepository<Team> {

  TeamRepository(DatabaseReference databaseReference, String? firebaseUserId)
    : super(databaseReference, DatabaseService.firebaseTeamsChild, firebaseUserId: firebaseUserId);

  // SET

  /// Upload Team data (insert)
  @override
  Future<void> saveItem(Team team) async {
    // check if the team exists already by using its id
    bool teamAlreadyExists = await itemExists(team.id!);
    if(!teamAlreadyExists) {
      // if the team is not found, check first if the team's name is unique, so that
      // no other team is stored with the same name
      bool isNameUnique = await isTeamNameUnique(team.name);
      if(!isNameUnique) {
        throw IntegrityException("The name of the new team already exists");
      }
    }
    await super.saveItem(team);
  }

  // UTILS

  /// Return true if the team name given is unique across all teams stored
  Future<bool> isTeamNameUnique(String newTeamName) async {
    Preconditions.requireArgumentNotEmpty(newTeamName);

    List<Team> teams = await getAllItems();
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
    return item.id!;
  }

}