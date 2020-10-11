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

  // do not use this field for non followed players
  String playerId;

  // the name also need to be stored for players not saved, not followed
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

  MatchPlayerData.empty() {
    var uuid = Uuid();
    id = uuid.v4();
    //playersId = uuid.v4();
    name = "Nome Giocatore";
    teamId = uuid.v4();
    startsFromBegin = true;
    shirtNumber = 1;
    numGoals = 0;
    setNoSubstitution();
    setNoCard();
  }

  MatchPlayerData.clone(MatchPlayerData data) {
    id = data.id;
    playerId = data.playerId;
    name = data.name;
    teamId = data.teamId;
    startsFromBegin = data.startsFromBegin;
    shirtNumber = data.shirtNumber;
    numGoals = data.numGoals;
    substitution = data.substitution;
    card = data.card;
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

  void setNoSubstitution() {
    substitution = SUBSTITUTION_NONE;
  }

  void setEnterSubstitution() {
    substitution = SUBSTITUTION_ENTERED;
  }

  void setExitSubstitution() {
    substitution = SUBSTITUTION_EXITED;
  }

  void setNoCard() {
    card = CARD_NONE;
  }

  void setYellowCard() {
    card = CARD_YELLOW;
  }

  void setDoubleYellowCard() {
    card = CARD_DOUBLE_YELLOW;
  }

  void setRedCard() {
    card = CARD_RED;
  }
}