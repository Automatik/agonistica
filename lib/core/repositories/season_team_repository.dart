import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class SeasonTeamRepository extends CrudRepository<SeasonTeam> {

  SeasonTeamRepository(DatabaseReference databaseReference, String? firebaseUserId)
    : super(databaseReference, DatabaseService.firebaseSeasonTeamsChild, firebaseUserId: firebaseUserId);



  @override
  Map<String, dynamic> itemToJson(SeasonTeam t) {
    return t.toJson();
  }

  @override
  SeasonTeam jsonToItem(Map<dynamic, dynamic> json) {
    return SeasonTeam.fromJson(json);
  }

  @override
  String getItemId(SeasonTeam item) {
    return item.id;
  }

}