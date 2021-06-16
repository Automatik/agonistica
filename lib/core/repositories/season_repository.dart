import 'package:agonistica/core/models/season.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class SeasonRepository extends CrudRepository<Season> {

  SeasonRepository(DatabaseReference databaseReference, String? firebaseUserId)
    : super(databaseReference, DatabaseService.firebaseSeasonsChild, firebaseUserId: firebaseUserId);

  @override
  Map<String, dynamic> itemToJson(Season t) {
    return t.toJson();
  }

  @override
  Season jsonToItem(Map<dynamic, dynamic> json) {
    return Season.fromJson(json);
  }

  @override
  String getItemId(Season item) {
    return item.id;
  }

}