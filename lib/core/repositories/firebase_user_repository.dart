import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/models/firebase_user.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseUserRepository extends CrudRepository<FirebaseUser> {

  FirebaseUserRepository(DatabaseReference databaseReference)
      : super(databaseReference, DatabaseService.firebaseUsersIdsChild);

  @override
  String getItemId(FirebaseUser item) {
    return item.id;
  }

  @override
  Map<String, dynamic> itemToJson(FirebaseUser item) {
    return item.toJson();
  }

  @override
  FirebaseUser jsonToItem(Map<dynamic, dynamic> json) {
    return FirebaseUser.fromJson(json);
  }

}