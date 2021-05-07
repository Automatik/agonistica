import 'dart:async';

import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/auth/auth_error.dart';
import 'package:agonistica/core/auth/auth_result.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/app_user.dart';
import 'package:agonistica/core/models/firebase_auth_user.dart';
import 'package:agonistica/core/utils/prefs_utils.dart';
import 'package:agonistica/views/home/home_view.dart';
import 'package:agonistica/views/login/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class LoginViewModel extends BaseViewModel {

  static const int SIGN_UP_ACTION = 0;
  static const int LOGIN_ACTION = 1;

  static Logger _logger = getLogger('LoginViewModel');

  final _appStateService = locator<AppStateService>();
  final _databaseService = locator<DatabaseService>();

  int currentAction;

  LoginViewModel();

  Future<String> loginUser(LoginData loginData) async {
    currentAction = LOGIN_ACTION;

    AuthResult authResult = await _databaseService.firebaseAuthUserService.loginUser(loginData.name, loginData.password);
    if(!authResult.isOk) {
      return authResult.errorMessage;
    }
    // Everything is ok
    _logger.d('User is signed in and email is verified!');
    FirebaseAuthUser firebaseAuthUser = authResult.firebaseAuthUser;

    bool appUserExists = await _databaseService.appUserService.itemExists(firebaseAuthUser.appUserId);
    if(!appUserExists) {
      String errorMessage = AuthError.firebaseErrorCodeToLoginDisplayError(AuthError.FIREBASE_ERROR_USER_NOT_FOUND);
      return errorMessage;
    }
    AppUser appUser = await _databaseService.appUserService.getItemById(firebaseAuthUser.appUserId);
    appUser.isEmailVerified = true;
    await _databaseService.appUserService.saveItem(appUser);

    await PrefsUtils.saveLoginUserInfo(appUser);

    _appStateService.selectedAppUser = appUser;

    await _databaseService.initializeUser();

    _logger.d("Sign in complete");
    return null;
  }

  Future<String> signUpUser(LoginData loginData) async {
    currentAction = SIGN_UP_ACTION;
    try {

      AuthResult authResult = await _databaseService.firebaseAuthUserService.signUpUser(loginData.name, loginData.password);
      if(!authResult.isOk) {
        return authResult.errorMessage;
      }
      // Everything is ok
      _logger.d('User is signed in and waiting for email verification!');
      FirebaseAuthUser firebaseAuthUser = authResult.firebaseAuthUser;

      AppUser appUser = AppUser(firebaseAuthUser.appUserId, loginData.name);

      await PrefsUtils.saveSignUpUserInfo(appUser);

      await _databaseService.firebaseAuthUserService.saveItem(firebaseAuthUser);
      await _databaseService.appUserService.saveItem(appUser);

      _appStateService.selectedAppUser = appUser;

      _logger.d("SignUp complete");
      return null;
    } catch(e) {
      _logger.e(e.toString());
      return "General error";
    }
  }

  Future<String> recoverPassword(String name) async {
    AuthResult authResult = await _databaseService.firebaseAuthUserService.resetUserPassword(name);
    if(!authResult.isOk) {
      return authResult.errorMessage;
    }

    _logger.d("Email with password rest sent for the user $name");

    return null;
  }

  Future<void> onSubmitAnimationCompleted(BuildContext context) async {
    switch(currentAction) {
      case SIGN_UP_ACTION:
        // Reload LoginView to wait for email validation (NON NECESSARIO CON NUOVA VERSIONE DI flutter_login utilizzando parametro loginAfterSignUp)
        await Navigator.of(context).pushReplacementNamed(LoginView.routeName);
        break;
      case LOGIN_ACTION:
        await Navigator.of(context).pushReplacementNamed(HomeView.routeName);
        break;
    }
  }

}