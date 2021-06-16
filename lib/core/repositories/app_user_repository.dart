

import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/models/app_user.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:firebase_database/firebase_database.dart';

class AppUserRepository extends CrudRepository<AppUser> {

  AppUserRepository(DatabaseReference databaseReference)
    : super(databaseReference, DatabaseService.firebaseUsersChild);

  @override
  String getItemId(AppUser item) {
    return item.id;
  }

  @override
  Map<String, dynamic> itemToJson(AppUser item) {
    return item.toJson();
  }

  @override
  AppUser jsonToItem(Map<dynamic, dynamic> json) {
    return AppUser.fromJson(json);
  }

}