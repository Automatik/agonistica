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
  static const String MESSAGE_CATEGORY_EMPTY = "Inserire un nome di categoria";
  static const String MESSAGE_CATEGORY_TOO_LONG = "Nome di categoria troppo lungo";
  static const String MESSAGE_CATEGORY_NOT_VALID = "Inserire un nome di categoria valido";
  static const String MESSAGE_RESULT_EMPTY = "Inserire un risultato";
  static const String MESSAGE_RESULT_NOT_VALID = "Inserire un risultato valido";
  static const String MESSAGE_LEAGUE_MATCH_EMPTY = "Inserire una giornata";
  static const String MESSAGE_LEAGUE_MATCH_NOT_VALID = "Inserire una giornata valida";
  static const String MESSAGE_INTEGERS_NOT_VALID = "Inserire valori interi validi";


  static const int _MAX_CHARS = 50;

  static String validatePlayerShirtNumber(String value) {
    if(value.isEmpty)
      return MESSAGE_SHIRT_EMPTY;
    int number = int.tryParse(value);
    if(number == null || !(number > 0 && number < 100))
      return MESSAGE_SHIRT_RANGE;
    return null; //Everything is ok
  }

  static String validatePlayerName(String value) {
    if(value.isEmpty)
      return MESSAGE_NAME_EMPTY;
    if(value.length > _MAX_CHARS)
      return MESSAGE_NAME_TOO_LONG;
    if(isPersonName(value))
      return null; //Everything is ok
    return MESSAGE_NAME_NOT_VALID;
  }

  static String validatePlayerSurname(String value) {
    if(value.isEmpty)
      return MESSAGE_SURNAME_EMPTY;
    if(value.length > _MAX_CHARS)
      return MESSAGE_SURNAME_TOO_LONG;
    if(isPersonSurname(value))
      return null; //Everything is ok
    return MESSAGE_SURNAME_NOT_VALID;
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
    if(value.isEmpty)
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