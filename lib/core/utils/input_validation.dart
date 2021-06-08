// @dart=2.9

import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/team.dart';

class InputValidation {

  static const String MESSAGE_SHIRT_EMPTY = "Inserire un numero di maglia";
  static const String MESSAGE_SHIRT_RANGE = "Numero deve essere compreso tra 1 e 99";
  static const String MESSAGE_NAME_EMPTY = "Inserire un nome";
  static const String MESSAGE_NAME_TOO_LONG = "Nome troppo lungo";
  static const String MESSAGE_NAME_NOT_VALID = "Inserire un nome valido";
  static const String MESSAGE_SURNAME_EMPTY = "Inserire un cognome";
  static const String MESSAGE_SURNAME_TOO_LONG = "Cognome troppo lungo";
  static const String MESSAGE_SURNAME_NOT_VALID = "Inserire un cognome valido";
  static const String MESSAGE_TEAM_EMPTY = "Inserire un nome di squadra";
  static const String MESSAGE_TEAM_TOO_LONG = "Nome di squadra troppo lungo";
  static const String MESSAGE_TEAM_NOT_VALID = "Inserire un nome di squadra valido";
  static const String MESSAGE_MENU_EMPTY = "Inserire un nome";
  static const String MESSAGE_MENU_TOO_LONG = "Nome inserito troppo lungo";
  static const String MESSAGE_MENU_NOT_VALID = "Inserire un nome valido";
  static const String MESSAGE_CATEGORY_EMPTY = "Inserire un nome di categoria";
  static const String MESSAGE_CATEGORY_TOO_LONG = "Nome di categoria troppo lungo";
  static const String MESSAGE_CATEGORY_NOT_VALID = "Inserire un nome di categoria valido";
  static const String MESSAGE_RESULT_EMPTY = "Inserire un risultato";
  static const String MESSAGE_RESULT_NOT_VALID = "Inserire un risultato valido";
  static const String MESSAGE_LEAGUE_MATCH_EMPTY = "Inserire una giornata";
  static const String MESSAGE_LEAGUE_MATCH_NOT_VALID = "Inserire una giornata valida";
  static const String MESSAGE_INTEGERS_NOT_VALID = "Inserire valori interi validi";
  static const String MESSAGE_EMAIL_EMPTY = "Inserire una email";
  static const String MESSAGE_EMAIL_TOO_LONG = "Email troppo lunga";
  static const String MESSAGE_EMAIL_NOT_VALID = "Inserire una email valida";
  static const String MESSAGE_PASSWORD_EMPTY = "Inserire una password";
  static const String MESSAGE_PASSWORD_TOO_LONG = "Password troppo lunga";
  static const String MESSAGE_PASSWORD_NOT_VALID = "Password deve essere almeno di 8 caratteri";


  static const int _MAX_CHARS = 50;
  static const int _MIN_PSW_LEN = 8;

  static String validateEmail(String value) {
    if(value.isEmpty)
      return MESSAGE_EMAIL_EMPTY;
    if(value.length > _MAX_CHARS)
      return MESSAGE_EMAIL_TOO_LONG;
    if(isEmailCorrect(value))
      return null;
    return MESSAGE_EMAIL_NOT_VALID;
  }

  static String validatePassword(String value) {
    if(value.isEmpty)
      return MESSAGE_PASSWORD_EMPTY;
    if(value.length > _MAX_CHARS)
      return MESSAGE_PASSWORD_TOO_LONG;
    if(value.length < _MIN_PSW_LEN)
      return MESSAGE_PASSWORD_NOT_VALID;
    return null;
  }

  static String validatePlayerShirtNumber(String value) {
    if(value.isEmpty)
      return MESSAGE_SHIRT_EMPTY;
    int number = int.tryParse(value);
    if(number == null || !(number > 0 && number < 100))
      return MESSAGE_SHIRT_RANGE;
    return null; //Everything is ok
  }

  static String validatePlayerName(String value) {
    if(value.isEmpty || Player.isEmptyName(value))
      return MESSAGE_NAME_EMPTY;
    if(value.length > _MAX_CHARS)
      return MESSAGE_NAME_TOO_LONG;
    if(isPersonName(value))
      return null; //Everything is ok
    return MESSAGE_NAME_NOT_VALID;
  }

  static String validatePlayerSurname(String value) {
    if(value.isEmpty || Player.isEmptySurname(value))
      return MESSAGE_SURNAME_EMPTY;
    if(value.length > _MAX_CHARS)
      return MESSAGE_SURNAME_TOO_LONG;
    if(isPersonSurname(value))
      return null; //Everything is ok
    return MESSAGE_SURNAME_NOT_VALID;
  }

  static String validateMenuName(String value) {
    if(value.isEmpty)
      return MESSAGE_MENU_EMPTY;
    if(value.length > _MAX_CHARS)
      return MESSAGE_MENU_TOO_LONG;
    if(isMenuName(value))
      return null; //Everything ok
    return MESSAGE_MENU_NOT_VALID;
  }

  static String validateCategoryName(String value) {
    if(value.isEmpty)
      return MESSAGE_CATEGORY_EMPTY;
    if(value.length > _MAX_CHARS)
      return MESSAGE_CATEGORY_TOO_LONG;
    if(isCategoryName(value))
      return null; //Everything is ok
    return MESSAGE_CATEGORY_NOT_VALID;
  }

  static String validateTeamName(String value) {
    if(value.isEmpty || Team.isEmptyName(value))
      return MESSAGE_TEAM_EMPTY;
    if(value.length > _MAX_CHARS)
      return MESSAGE_TEAM_TOO_LONG;
    if(isTeamName(value))
      return null; //Everything is ok
    return MESSAGE_TEAM_NOT_VALID;
  }

  static String validateResultGoal(String value) {
    if(value.isEmpty)
      return MESSAGE_RESULT_EMPTY;
    if(isInteger(value))
      return null;
    return MESSAGE_RESULT_NOT_VALID;
  }

  static String validateLeagueMatch(String value) {
    if(value.isEmpty)
      return MESSAGE_LEAGUE_MATCH_EMPTY;
    if(isInteger(value))
      return null;
    return MESSAGE_LEAGUE_MATCH_NOT_VALID;
  }

  /// Check if the string value is a valid integer for values like height,
  /// weight, number of matches, goals, etc. It's not needed to check for
  /// empty value
  static String validateInteger(String value) {
    if(value.isEmpty || isInteger(value))
      return null; //Everything ok
    return MESSAGE_INTEGERS_NOT_VALID;
  }

  static bool isEmailCorrect(String email) {
    RegExp regExp = new RegExp(
      r"^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$",
      caseSensitive: false,
      multiLine: false,
    );
    return regExp.hasMatch(email);
  }

  static bool isPersonName(String name) {
    RegExp regExp = RegExp(
      r"^[a-z]{2,30}\s?'?-?([a-zòàèé]){1,30}?$",
      caseSensitive: false,
      multiLine: false,
    );

    // https://stackoverflow.com/a/40056630

    return regExp.hasMatch(name);
  }

  /// Valid for surnames like
  /// Rossi
  /// De
  /// De Luca
  /// De Luca Banti
  /// De Luca Banti Quarto
  /// Dr V
  /// Dr Vin Mat
  /// Dr Vi Ma
  /// O'ra
  /// O'Horizon
  /// Or'Vate
  /// Mac-David
  static bool isPersonSurname(String surname) {
    RegExp regExp = RegExp(
      r"^([a-z]{1,30}'{1})?([a-zòàèé]{2,30})(\s?'?-?[a-zòàèé]{1,30}){0,3}?$",
      caseSensitive: false,
      multiLine: false,
    );
    return regExp.hasMatch(surname);
  }

  /// The menu can be the name of a team or a name of a macro-category,
  /// so use the isTeamName and isCategoryName functions
  static bool isMenuName(String menu) {
    return isTeamName(menu) || isCategoryName(menu);
  }

  /// Valid for categories like
  /// Juniores
  /// Juniores Regionali
  /// Juniores Regionali A
  /// Juniores Regionali A Girone B
  /// Jun
  /// Juni Re
  /// But not for categories like
  /// Ju
  /// J
  /// Ju Re
  static bool isCategoryName(String category) {
    RegExp regExp = RegExp(
      r"^([a-zòàèé]{3,30})(\s?'?-?[a-zòàèé]{1,30}){0,6}?$",
      caseSensitive: false,
      multiLine: false,
    );
    return regExp.hasMatch(category);
  }

  static bool isTeamName(String team) {
    RegExp regExp = RegExp(
      r"^([a-zòàèé]{2,30})?([a-zòàèé]{2,30})(\s?'?-?[a-zòàèé0-9]{2,30}){0,3}?$",
      caseSensitive: false,
      multiLine: false,
    );
    return regExp.hasMatch(team);
  }

  static bool isInteger(String number) {
    RegExp regExp = RegExp(
      r"^[0-9]{1,3}$",
      caseSensitive: false,
      multiLine: false,
    );
    return regExp.hasMatch(number);
  }

}