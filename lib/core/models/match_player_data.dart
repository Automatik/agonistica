import 'package:agonistica/core/assets/icon_assets.dart';
import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/utils/db_utils.dart';

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

  String seasonPlayerId;

  // the name and surname fields are updated every time the player card is
  // modified in databaseService.savePlayer()
  String name, surname;

  String seasonTeamId;

  bool isRegular; // is regular player or a reserve

  int shirtNumber;
  int numGoals;
  int substitution;
  int card;

  MatchPlayerData() {
    id = DbUtils.newUuid();
  }

  bool isEmptyPlayer() {
    //Eventually reduce to only checking if playerId is null
    return seasonPlayerId == null && name == EMPTY_PLAYER_NAME && surname == EMPTY_PLAYER_SURNAME;
  }

  MatchPlayerData.empty(String teamId, {bool isRegular = true}) {
    Preconditions.requireArgumentNotEmpty(teamId);

    id = DbUtils.newUuid();
    seasonPlayerId = null;
    name = EMPTY_PLAYER_NAME;
    surname = EMPTY_PLAYER_SURNAME;
    this.seasonTeamId = teamId;
    this.isRegular = isRegular;
    shirtNumber = 0;
    numGoals = 0;
    setNoSubstitution();
    setNoCard();
  }

  MatchPlayerData.clone(MatchPlayerData data) {
    id = data.id;
    seasonPlayerId = data.seasonPlayerId;
    name = data.name;
    surname = data.surname;
    seasonTeamId = data.seasonTeamId;
    isRegular = data.isRegular;
    shirtNumber = data.shirtNumber;
    numGoals = data.numGoals;
    substitution = data.substitution;
    card = data.card;
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'seasonPlayerId': seasonPlayerId,
      'name': name,
      'surname': surname,
      'seasonTeamId': seasonTeamId,
      'isRegular': isRegular,
      'shirtNumber': shirtNumber,
      'numGoals': numGoals,
      'substitution': substitution,
      'card': card
    };
  }

  MatchPlayerData.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      seasonPlayerId = json['seasonPlayerId'],
      name = json['name'],
      surname = json['surname'],
      seasonTeamId = json['seasonTeamId'],
      isRegular = json['isRegular'],
      shirtNumber = json['shirtNumber'],
      numGoals = json['numGoals'],
      substitution = json['substitution'],
      card = json['card'];

  /// Create a new SeasonPlayer object from this MatchPlayerData object, assuming
  /// it's the player's first match
  SeasonPlayer toSeasonPlayer(String categoryId, String seasonId) {
    Player p = Player.empty();
    p.name = name;
    p.surname = surname;

    SeasonPlayer sp = SeasonPlayer.empty(p.id, seasonTeamId, seasonId, categoryId);
    sp.id = seasonPlayerId;
    sp.player = p;

    // match data
    // In databaseService.saveMatch this data is re-calculated to avoid mistakes
    sp.matches = 1;
    sp.goals = numGoals;
    sp.yellowCards = getYellowCardsCount();
    sp.redCards = getRedCardCount();

    return sp;
  }

  int getYellowCardsCount() {
    switch(card) {
      case CARD_YELLOW: return 1;
      case CARD_DOUBLE_YELLOW: return 2;
      default: return 0;
    }
  }

  int getRedCardCount() {
    return card == CARD_RED ? 1 : 0;
  }

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
      case CARD_YELLOW: assetName = IconAssets.ICON_YELLOW_CARD; break;
      case CARD_DOUBLE_YELLOW: assetName = IconAssets.ICON_DOUBLE_YELLOW_CARD; break;
      case CARD_RED: assetName = IconAssets.ICON_RED_CARD; break;
      default: assetName = "";
    }
    return assetName;
  }

  static String getSubstitutionAsset(int substitution) {
    String assetName;
    switch(substitution) {
      case SUBSTITUTION_EXITED: assetName = IconAssets.ICON_SUBSTITUTION_EXIT; break;
      case SUBSTITUTION_ENTERED: assetName = IconAssets.ICON_SUBSTITUTION_ENTER; break;
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

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("seasonPlayerId", seasonPlayerId);
    Preconditions.requireFieldNotEmpty("name", name);
    Preconditions.requireFieldNotEmpty("surname", surname);
    Preconditions.requireFieldNotEmpty("seasonTeamId", seasonTeamId);
  }

}