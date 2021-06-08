// @dart=2.9

import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class FirebaseAuthUser {

  String id; // firebase auth id
  String appUserId;

  //Temporary
  String email;
  String password;

  FirebaseAuthUser(String authId, String email, String password) {
    this.id = authId;
    appUserId = DbUtils.newUuid();
    this.email = email;
    this.password = password;
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'appUserId': appUserId
    };
  }

  FirebaseAuthUser.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      appUserId = json['appUserId'];

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("appUserId", appUserId);
  }

}