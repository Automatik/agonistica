import 'package:uuid/uuid.dart';

class MatchPlayerData {

  static const int SUBSTITUTION_NONE = 0;
  static const int SUBSTITUTION_ENTERED = 1;
  static const int SUBSTITUTION_EXITED = 2;

  static const int CARD_NONE = 0;
  static const int CARD_YELLOW = 1;
  static const int CARD_DOUBLE_YELLOW = 2;
  static const int CARD_RED = 3;

  static const String EMPTY_PLAYER_NAME = "Nome";
  static const String EMPTY_PLAYER_SURNAME = "Giocatore";

  String id;

  // do not use this field for non followed players -> Da rivedere: se io aggiungo un player tramite MatchPlayerData a una partita e poi in un secondo momento voglio creare un vero e proprio Player? Avere già un playerId aiuta a ricollegare tutte le partite di quel giocatore
  String playerId;

  // the name also need to be stored for players not followed by the scouts
  // I expect that if I edit a player's name from the match view should be propagated accordingly through playerId
  // And I expect that if the player's name is updated elsewhere, also here the name should be updated
  // handled this in the service
  String name, surname;

  String teamId;

  bool isRegular; // is regular player or a reserve

  int shirtNumber;
  int numGoals;
  int substitution;
  int card;

  MatchPlayerData() {
    var uuid = Uuid();
    id = uuid.v4();
  }

  MatchPlayerData.empty(String teamId, {bool isRegular = true}) {
    var uuid = Uuid();
    id = uuid.v4();
    playerId = null;
    name = EMPTY_PLAYER_NAME;
    surname = EMPTY_PLAYER_SURNAME;
    this.teamId = teamId;
    this.isRegular = isRegular;
    shirtNumber = 0;
    numGoals = 0;
    setNoSubstitution();
    setNoCard();
  }

  MatchPlayerData.clone(MatchPlayerData data) {
    id = data.id;
    playerId = data.playerId;
    name = data.name;
    surname = data.surname;
    teamId = data.teamId;
    isRegular = data.isRegular;
    shirtNumber = data.shirtNumber;
    numGoals = data.numGoals;
    substitution = data.substitution;
    card = data.card;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'playerId': playerId,
    'name': name,
    'surname': surname,
    'teamId': teamId,
    'isRegular': isRegular,
    'shirtNumber': shirtNumber,
    'numGoals': numGoals,
    'substitution': substitution,
    'card': card
  };

  MatchPlayerData.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      playerId = json['playerId'],
      name = json['name'],
      surname = json['surname'],
      teamId = json['teamId'],
      isRegular = json['isRegular'],
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

  static String getCardAsset(int card) {
    String assetName;
    switch(card) {
      case CARD_YELLOW: assetName = "assets/images/018-yellow-card.svg"; break;
      case CARD_DOUBLE_YELLOW: assetName = "assets/images/039-amonestation.svg"; break;
      case CARD_RED: assetName = "assets/images/026-red-card.svg"; break;
      default: assetName = "";
    }
    return assetName;
  }

  static String getSubstitutionAsset(int substitution) {
    String assetName;
    switch(substitution) {
      case SUBSTITUTION_EXITED: assetName = "assets/images/008-change-1.svg"; break;
      case SUBSTITUTION_ENTERED: assetName = "assets/images/009-change.svg"; break;
      default: assetName = "";
    }
    return assetName;
  }

  static String getCardText(int card) {
    switch(card) {
      case CARD_YELLOW: return "Ammoniz.";
      case CARD_DOUBLE_YELLOW: return "Dopp. Ammoniz.";
      case CARD_RED: return "Espulso";
      default: return "Nessuno";
    }
  }

  static String getSubstitutionText(int substitution) {
    switch(substitution) {
      case SUBSTITUTION_EXITED: return "Uscito";
      case SUBSTITUTION_ENTERED: return "Entrato";
      default: return "Nessuno";
    }
  }


}