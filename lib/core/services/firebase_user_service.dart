import 'package:agonistica/core/models/firebase_user.dart';
import 'package:agonistica/core/repositories/firebase_user_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseUserService extends CrudService<FirebaseUser> {

  FirebaseUserService(DatabaseReference databaseReference)
    : super(databaseReference, FirebaseUserRepository(databaseReference));

  Future<String> getAppUserIdFromFirebaseUser(String firebaseUserId) async {
    FirebaseUser firebaseUser = await getItemById(firebaseUserId);
    return firebaseUser.appUserId;
  }

}