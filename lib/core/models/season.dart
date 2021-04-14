import 'package:agonistica/core/guards/preconditions.dart';
import 'package:uuid/uuid.dart';

class Season {

  static const int SEASON_SEPARATOR_DAY = 31;
  static const int SEASON_SEPARATOR_MONTH = DateTime.july;

  String id;

  String period; // es. 2020/21
  int beginYear; // es. 2020
  int endYear; // es. 2021

  Season() {
    var uuid = Uuid();
    id = uuid.v4();
  }

  Season.create(int beginYear, int endYear) {
    Preconditions.requireArgumentGreaterThanZero(beginYear);
    Preconditions.requireArgumentGreaterThanZero(endYear);
    Preconditions.requireArgumentGreaterThan(endYear, beginYear);

    var uuid = Uuid();
    id = uuid.v4();
    this.beginYear = beginYear;
    this.endYear = endYear;
    period = yearsToString(beginYear, endYear);
  }

  Season.createCurrentSeason() {
    DateTime currentDate = DateTime.now();
    int currentYear = currentDate.year;
    DateTime seasonSeparatorDate = DateTime(currentYear, SEASON_SEPARATOR_MONTH, SEASON_SEPARATOR_DAY);
    int beginYear, endYear;
    if(currentDate.isAfter(seasonSeparatorDate)) {
      // If it is the beginning of the new season (current date after 31 July)
      beginYear = currentYear;
      endYear = currentYear + 1;
    } else {
      // it is the ending of the current season (current date before 31 July)
      beginYear = currentYear - 1;
      endYear = currentYear;
    }
    Season.create(beginYear, endYear);
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'beginYear': beginYear,
      'endYear': endYear,
      'period': period
    };
  }

  Season.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      beginYear = json['beginYear'],
      endYear = json['endYear'],
      period = json['period'];

  /// Compose the period string from the begin and end year
  /// Example beginYear=2020 and endYear=2021 -> return "2020/21"
  static String yearsToString(int beginYear, int endYear) {
    String begin = beginYear.toString();
    String end = endYear.toString();
    String subEnd = end.substring(end.length - 2);
    return "$begin/$subEnd";
  }

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotNull("beginYear", beginYear);
    Preconditions.requireFieldNotNull("endYear", endYear);
    Preconditions.requireFieldNotEmpty("period", period);
    Preconditions.requireFieldGreaterThanZero("beginYear", beginYear);
    Preconditions.requireFieldGreaterThanZero("endYear", endYear);
    Preconditions.requireFieldGreaterThan("endYear", endYear, beginYear);
  }

}