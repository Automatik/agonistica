import 'package:uuid/uuid.dart';

class MatchPlayerData {

  static const int SUBSTITUTION_NONE = 0;
  static const int SUBSTITUTION_ENTERED = 1;
  static const int SUBSTITUTION_EXITED = 2;

  static const int CARD_NONE = 0;
  static const int CARD_YELLOW = 1;
  static const int CARD_DOUBLE_YELLOW = 2;
  static const int CARD_RED = 3;

  String id;

  String playerId;
  String name;

  String teamId;

  bool startsFromBegin;

  int shirtNumber;
  int numGoals;
  int substitution;
  int card;

  MatchPlayerData() {
    var uuid = Uuid();
    id = uuid.v4();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'playerId': playerId,
    'name': name,
    'teamId': teamId,
    'startsFromBegin': startsFromBegin,
    'shirtNumber': shirtNumber,
    'numGoals': numGoals,
    'substitution': substitution,
    'card': card
  };

  MatchPlayerData.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      playerId = json['playerId'],
      name = json['name'],
      teamId = json['teamId'],
      startsFromBegin = json['startsFromBegin'],
      shirtNumber = json['shirtNumber'],
      numGoals = json['numGoals'],
      substitution = json['substitution'],
      card = json['card'];

}