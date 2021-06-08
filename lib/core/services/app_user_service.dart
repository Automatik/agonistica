// @dart=2.9

import 'package:agonistica/core/models/app_user.dart';
import 'package:agonistica/core/repositories/app_user_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:firebase_database/firebase_database.dart';

class AppUserService extends CrudService<AppUser> {

  AppUserService(DatabaseReference databaseReference)
    : super(databaseReference, AppUserRepository(databaseReference));



}