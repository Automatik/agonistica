class InputValidation {

  static const String MESSAGE_SHIRT_EMPTY = "Inserire un numero di maglia";
  static const String MESSAGE_SHIRT_RANGE = "Numero deve essere compreso tra 1 e 99";
  static const String MESSAGE_NAME_EMPTY = "Inserire un nome";
  static const String MESSAGE_NAME_TOO_LONG = "Nome troppo lungo";
  static const String MESSAGE_NAME_NOT_VALID = "Inserire un nome valido";
  static const String MESSAGE_SURNAME_EMPTY = "Inserire un cognome";
  static const String MESSAGE_SURNAME_TOO_LONG = "Cognome troppo lungo";
  static const String MESSAGE_SURNAME_NOT_VALID = "Inserire un cognome valido";

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

}