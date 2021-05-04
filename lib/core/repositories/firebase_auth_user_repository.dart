import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/models/firebase_auth_user.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseAuthUserRepository extends CrudRepository<FirebaseAuthUser> {

  FirebaseAuthUserRepository(DatabaseReference databaseReference)
      : super(databaseReference, DatabaseService.firebaseUsersIdsChild);

  @override
  String getItemId(FirebaseAuthUser item) {
    return item.id;
  }

  @override
  Map<String, dynamic> itemToJson(FirebaseAuthUser item) {
    return item.toJson();
  }

  @override
  FirebaseAuthUser jsonToItem(Map<dynamic, dynamic> json) {
    return FirebaseAuthUser.fromJson(json);
  }

}