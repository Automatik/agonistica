import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class AppUser {

  String id;

  // Personal Data
  String email;
  bool isEmailVerified;

  AppUser._() {} // private constructor

  /// The id is generated from the FirebaseAuthUser because the latter is created first
  AppUser(String id) {
    this.id = id;
  }

  Map<String, dynamic> toJson()  {
    checkRequiredFields();

    return {
      'id': id,
      'email': email,
      'emailVerified': isEmailVerified
    };
  }

  AppUser.fromJson(Map<dynamic, dynamic> json)
   : id = json['id'],
     email = json['email'],
     isEmailVerified = json['emailVerified'] == null ? false : json['emailVerified'];

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("email", email);
  }
}