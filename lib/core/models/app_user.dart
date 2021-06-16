import 'package:agonistica/core/guards/preconditions.dart';

class AppUser {

  late String id;

  // Personal Data
  late String email;
  late bool isEmailVerified;

  // App Data
  late bool areItemsInitialized; // true if the requested items are created

  AppUser._(); // private constructor

  /// The id is generated from the FirebaseAuthUser because the latter is created first
  AppUser(String id, String email) {
    this.id = id;
    this.email = email;
    isEmailVerified = false;
    areItemsInitialized = false;
  }

  Map<String, dynamic> toJson()  {
    checkRequiredFields();

    return {
      'id': id,
      'email': email,
      'emailVerified': isEmailVerified,
      'areItemsInitialized': areItemsInitialized
    };
  }

  AppUser.fromJson(Map<dynamic, dynamic> json)
   : id = json['id'],
     email = json['email'],
     isEmailVerified = json['emailVerified'] == null ? false : json['emailVerified'],
     areItemsInitialized = json['areItemsInitialized'] == null ? false : json['areItemsInitialized'];

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("email", email);
  }
}