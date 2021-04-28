import 'package:agonistica/core/guards/preconditions.dart';

class FirebaseUser {

  String id;
  String appUserId;

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'appUserId': appUserId
    };
  }

  FirebaseUser.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      appUserId = json['appUserId'];

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("appUserId", appUserId);
  }

}