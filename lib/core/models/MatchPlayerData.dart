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

}