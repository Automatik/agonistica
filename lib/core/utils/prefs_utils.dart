

import 'package:agonistica/core/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsUtils {

  static const String isRegisteredKey = 'isRegistered';
  static const String isLoggedKey = 'isLogged';
  static const String isVerifiedKey = 'isEmailVerified';
  static const String loginEmailKey = 'loginEmail';
  static const String loginUserIdKey = 'loginUserId';

  static Future<void> saveSignUpUserInfo(AppUser appUser) async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(isRegisteredKey, true);
      prefs.setBool(isLoggedKey, false);
      prefs.setString(loginUserIdKey, appUser.id!);
      prefs.setString(loginEmailKey, appUser.email!);
      prefs.setBool(isVerifiedKey, appUser.isEmailVerified!);
    });
  }

  static Future<void> saveLoginUserInfo(AppUser appUser) async {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(isRegisteredKey, true);
      prefs.setBool(isLoggedKey, true);
      prefs.setString(loginUserIdKey, appUser.id!);
      prefs.setString(loginEmailKey, appUser.email!);
      prefs.setBool(isVerifiedKey, appUser.isEmailVerified!);
    });
  }

  static Future<bool> isUserSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedKey) ?? false;
  }

  static Future<bool> isUserSignedUp() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isRegisteredKey) ?? false;
  }

  static Future<bool> isEmailVerified() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isVerifiedKey) ?? false;
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(loginUserIdKey);
  }

}