// @dart=2.9

import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class MatchRepository extends CrudRepository<Match> {

  MatchRepository(DatabaseReference databaseReference, String firebaseUserId)
    : super(databaseReference, DatabaseService.firebaseMatchesChild, firebaseUserId: firebaseUserId);

  @override
  Map<String, dynamic> itemToJson(Match t) {
    return t.toJson();
  }

  @override
  Match jsonToItem(Map<dynamic, dynamic> json) {
    return Match.fromJson(json);
  }

  @override
  String getItemId(Match item) {
    return item.id;
  }

}