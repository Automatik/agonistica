import 'package:agonistica/core/models/firebase_auth_user.dart';
import 'package:flutter/material.dart';

class AuthResult {

  bool isOk;
  String? errorMessage;
  FirebaseAuthUser? firebaseAuthUser;

  AuthResult({
    required this.isOk,
    this.errorMessage,
    this.firebaseAuthUser,
  }) : assert((isOk == true && errorMessage == null && firebaseAuthUser != null)
            || (isOk == false && errorMessage != null && firebaseAuthUser == null));


}