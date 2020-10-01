import 'package:uuid/uuid.dart';

class Player {

  static const int POSITION_FORWARD = 0;
  static const int POSITION_MIDFIELDER = 1;
  static const int POSITION_DEFENDER = 2;
  static const int POSITION_GOALKEEPER = 3;

  static const int MIN_VALUE = 0;
  static const int MAX_VALUE = 10;

  String id;
  String name, surname;
  String teamId;
  String categoryId;

  DateTime birthDay;
  int height;
  double weight;

  int position;
  bool isRightHanded;

  int matches, goals, yellowCards, redCards;

  //Player's characteristics
  int tecnica, agonistica, fisica, tattica, capMotorie;

  //Player's conditional capacities
  int velocita, rapidita, scatto, resistenza, corsa, progressione, cambioPasso, elevazione;

  String morfologia, sommatoTipo;

  String attitudine1, attitudine2, attitudine3;

  List<String> matchesIds;
  List<String> playerMatchNotesIds;

  Player() {
    var uuid = Uuid();
    id = uuid.v4();
  }

  static String positionToString(int position) {
    switch(position) {
      case POSITION_FORWARD: return "Attaccante";
      case POSITION_MIDFIELDER: return "Centrocampista";
      case POSITION_DEFENDER: return "Difensore";
      case POSITION_GOALKEEPER: return "Portiere";
      default: return "N/A";
    }
  }

}