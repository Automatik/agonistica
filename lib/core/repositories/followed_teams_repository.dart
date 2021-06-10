

import 'package:agonistica/core/models/followed_teams.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class FollowedTeamsRepository extends CrudRepository<FollowedTeams> {

  FollowedTeamsRepository(DatabaseReference databaseReference, String? firebaseUserId)
      : super(databaseReference, DatabaseService.firebaseFollowedTeamsChild, firebaseUserId: firebaseUserId);

  @override
  Map<String, dynamic> itemToJson(FollowedTeams t) {
    return t.toJson();
  }

  @override
  FollowedTeams jsonToItem(Map<dynamic, dynamic> json) {
    return FollowedTeams.fromJson(json);
  }

  @override
  String getItemId(FollowedTeams item) {
    return item.id!;
  }

}