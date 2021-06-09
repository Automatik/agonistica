class MyDateUtils {

  static String monthToString(int month) {
    if(month < 1 || month > 12)
      return "";
    switch (month) {
      case 1 : return "Gennaio";
      case 2: return "Febbraio";
      case 3: return "Marzo";
      case 4: return "Aprile";
      case 5: return "Maggio";
      case 6: return "Giugno";
      case 7: return "Luglio";
      case 8: return "Agosto";
      case 9: return "Settembre";
      case 10: return "Ottobre";
      case 11: return "Novembre";
      case 12: return "Dicembre";
      default: return "";
    }
  }

  /// Use this to clone DateTime
  static DateTime fromDateTime(
      DateTime src, {
        int? year,
        int? month,
        int? day,
        int? hour,
        int? minute,
        int? second,
        int? millisecond}) {
    return new DateTime(
        year == null ? src.year : year,
        month == null ? src.month : month,
        day == null ? src.day : day,
        hour == null ? src.hour : hour,
        minute == null ? src.minute : minute,
        second == null ? src.second : second,
        millisecond == null ? src.millisecond : millisecond
    );
  }

}