import 'package:agonistica/core/guards/preconditions.dart';
import 'package:uuid/uuid.dart';

class Season {

  String id;

  String period; // es. 2020/21
  int beginYear; // es. 2020
  int endYear; // es. 2021

  Season() {
    var uuid = Uuid();
    id = uuid.v4();
  }

  //TODO In SeasonRepository check no other season with same beginYear and endYear exist
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
    Preconditions.requireFieldNotNull("id", id);
    Preconditions.requireFieldNotNull("beginYear", beginYear);
    Preconditions.requireFieldNotNull("endYear", endYear);
    Preconditions.requireFieldNotNull("period", period);
    Preconditions.requireFieldGreaterThanZero("beginYear", beginYear);
    Preconditions.requireFieldGreaterThanZero("endYear", endYear);
    Preconditions.requireFieldGreaterThan("endYear", endYear, beginYear);
  }

}