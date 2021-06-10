import 'package:agonistica/core/utils/my_strings.dart';
import 'package:flutter/material.dart';

class AuthError {

  static const String FIREBASE_ERROR_INVALID_EMAIL = "invalid-email";
  static const String FIREBASE_ERROR_USER_DISABLED = "user-disabled";
  static const String FIREBASE_ERROR_USER_NOT_FOUND = "user-not-found";
  static const String FIREBASE_ERROR_WRONG_PASSWORD = "wrong-password";
  static const String FIREBASE_ERROR_EMAIL_ALREADY_IN_USE = "email-already-in-use";
  static const String FIREBASE_ERROR_OPERATION_NOT_ALLOWED = "operation-not-allowed";
  static const String FIREBASE_ERROR_WEAK_PASSWORD = "weak-password";
  static const String MY_FIREBASE_ERROR_GENERAL_ERROR = "general-error";
  static const String MY_FIREBASE_ERROR_EMAIL_NOT_VERIFIED = "email-not-verified";

  bool isError;
  String? errorCode;

  AuthError({
    required this.isError,
    this.errorCode
  }) : assert((isError == true && errorCode != null)
            || (isError == false && errorCode == null));

  static String firebaseErrorCodeToLoginDisplayError(String code) {
    switch (code) {
      case FIREBASE_ERROR_INVALID_EMAIL: return MyStrings.FIREBASE_ERROR_LOGIN_INVALID_EMAIL;
      case FIREBASE_ERROR_USER_DISABLED: return MyStrings.FIREBASE_ERROR_LOGIN_USER_DISABLED;
      case FIREBASE_ERROR_USER_NOT_FOUND: return MyStrings.FIREBASE_ERROR_LOGIN_USER_NOT_FOUND;
      case FIREBASE_ERROR_WRONG_PASSWORD: return MyStrings.FIREBASE_ERROR_LOGIN_WRONG_PASSWORD;
      default: return MyStrings.FIREBASE_ERROR_DEFAULT;
    }
  }

  static String firebaseErrorCodeToRegisterDisplayError(String code) {
    switch (code) {
      case FIREBASE_ERROR_EMAIL_ALREADY_IN_USE: return MyStrings.FIREBASE_ERROR_REGISTER_EMAIL_ALREADY_IN_USE;
      case FIREBASE_ERROR_INVALID_EMAIL: return MyStrings.FIREBASE_ERROR_REGISTER_INVALID_EMAIL;
      case FIREBASE_ERROR_OPERATION_NOT_ALLOWED: return MyStrings.FIREBASE_ERROR_REGISTER_OPERATION_NOT_ALLOWED;
      case FIREBASE_ERROR_WEAK_PASSWORD: return MyStrings.FIREBASE_ERROR_REGISTER_WEAK_PASSWORD;
      default: return MyStrings.FIREBASE_ERROR_DEFAULT;
    }
  }

}