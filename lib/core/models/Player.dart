import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/models/Category.dart';
import 'package:agonistica/core/models/MatchPlayerData.dart';
import 'package:agonistica/core/models/PlayerMatchNotes.dart';
import 'package:agonistica/core/models/Team.dart';
import 'package:agonistica/core/utils/date_utils.dart';
import 'package:uuid/uuid.dart';

class Player {

  static const int POSITION_FORWARD = 0;
  static const int POSITION_MIDFIELDER = 1;
  static const int POSITION_DEFENDER = 2;
  static const int POSITION_GOALKEEPER = 3;

  static const int MIN_VALUE = 1;
  static const int MAX_VALUE = 10;

  String id;
  String name, surname;
  String teamId;
  String categoryId;

  //Only temporary
  String teamName;
  String categoryName;

  DateTime birthDay;
  int height;
  int weight;

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

  // Only temporary, do not store
  List<PlayerMatchNotes> playerMatchesNotes;

  Player() {
    var uuid = Uuid();
    id = uuid.v4();
  }

  Player.empty() {
    var uuid = Uuid();
    id = uuid.v4();
    name = "Nome";
    surname = "Cognome";
    teamId = uuid.v4();
    categoryId = uuid.v4();
    birthDay = DateTime.utc(2020, 1, 1);
    height = 0;
    weight = 0;
    position = POSITION_MIDFIELDER;
    isRightHanded = true;

    resetStats();

    tecnica = agonistica = fisica = tattica = capMotorie = MIN_VALUE;

    velocita = rapidita = scatto = resistenza = corsa = progressione = cambioPasso = elevazione = MIN_VALUE;

    morfologia = sommatoTipo = "";

    attitudine1 = attitudine2 = attitudine3 = "";

    matchesIds = List();
    playerMatchNotesIds = List();
  }

  Player.clone(Player p) {
    id = p.id;
    name = p.name;
    surname = p.surname;
    teamId = p.teamId;
    teamName = p.teamName;
    categoryId = p.categoryId;
    categoryName = p.categoryName;
    birthDay = DateUtils.fromDateTime(p.birthDay);
    height = p.height;
    weight = p.weight;
    position = p.position;
    isRightHanded = p.isRightHanded;

    matches = p.matches;
    goals = p.goals;
    yellowCards = p.yellowCards;
    redCards = p.redCards;

    tecnica = p.tecnica;
    agonistica = p.agonistica;
    fisica = p.fisica;
    tattica = p.tattica;
    capMotorie = p.capMotorie;

    velocita = p.velocita;
    rapidita = p.rapidita;
    scatto = p.scatto;
    resistenza = p.resistenza;
    corsa = p.corsa;
    progressione = p.progressione;
    cambioPasso = p.cambioPasso;
    elevazione = p.elevazione;

    morfologia = p.morfologia;
    sommatoTipo = p.sommatoTipo;

    attitudine1 = p.attitudine1;
    attitudine2 = p.attitudine2;
    attitudine3 = p.attitudine3;

    matchesIds = List.from(p.matchesIds ?? []);
    playerMatchNotesIds = List.from(p.playerMatchNotesIds ?? []);
  }

  /// Reset stats before updating them by summing all the match player data
  void resetStats() {
    matches = goals = yellowCards = redCards = 0;
  }

  void updateFromMatch(MatchPlayerData playerData) {
    matches += 1;
    goals += playerData.numGoals;
    yellowCards += playerData.getYellowCardsCount();
    redCards += playerData.getRedCardCount();
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'name': name,
      'surname': surname,
      'teamId': teamId,
      'categoryId': categoryId,
      'birthDay': birthDay.toIso8601String(),
      'height': height,
      'weight': weight,
      'position': position,
      'isRightHanded': isRightHanded,
      'matches': matches,
      'goals': goals,
      'yellowCards': yellowCards,
      'redCards': redCards,
      'tecnica': tecnica,
      'agonistica': agonistica,
      'fisica': fisica,
      'tattica': tattica,
      'capMotorie': capMotorie,
      'velocita': velocita,
      'rapidita': rapidita,
      'scatto': scatto,
      'resistenza': resistenza,
      'corsa': corsa,
      'progressione': progressione,
      'cambioPasso': cambioPasso,
      'elevazione': elevazione,
      'morfologia': morfologia,
      'sommatoTipo': sommatoTipo,
      'attitudine1': attitudine1,
      'attitudine2': attitudine2,
      'attitudine3': attitudine3,
      'matchesIds': matchesIds == null ? List() : matchesIds,
      'playerMatchNotesIds': playerMatchNotesIds == null
          ? List()
          : playerMatchNotesIds
    };
  }

  Player.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      name = json['name'],
      surname = json['surname'],
      teamId = json['teamId'],
      categoryId = json['categoryId'],
      birthDay = DateTime.tryParse(json['birthDay']),
      height = json['height'],
      weight = json['weight'],
      position = json['position'],
      isRightHanded = json['isRightHanded'],
      matches = json['matches'],
      goals = json['goals'],
      yellowCards = json['yellowCards'],
      redCards = json['redCards'],
      tecnica = json['tecnica'],
      agonistica = json['agonistica'],
      fisica = json['fisica'],
      tattica = json['tattica'],
      capMotorie = json['capMotorie'],
      velocita = json['velocita'],
      rapidita = json['rapidita'],
      scatto = json['scatto'],
      resistenza = json['resistenza'],
      corsa = json['corsa'],
      progressione = json['progressione'],
      cambioPasso = json['cambioPasso'],
      elevazione = json['elevazione'],
      morfologia = json['morfologia'],
      sommatoTipo = json['sommatoTipo'],
      attitudine1 = json['attitudine1'],
      attitudine2 = json['attitudine2'],
      attitudine3 = json['attitudine3'],
      matchesIds = json['matchesIds'] == null ? List() : List<String>.from(json['matchesIds']),
      playerMatchNotesIds = json['playerMatchNotesIds'] == null ? List(): List<String>.from(json['playerMatchNotesIds']);

  static String positionToString(int position) {
    switch(position) {
      case POSITION_FORWARD: return "Attaccante";
      case POSITION_MIDFIELDER: return "Centrocampista";
      case POSITION_DEFENDER: return "Difensore";
      case POSITION_GOALKEEPER: return "Portiere";
      default: return "N/A";
    }
  }

  static int stringToPosition(String position) {
    switch(position) {
      case "Attaccante": return POSITION_FORWARD;
      case "Centrocampista": return POSITION_MIDFIELDER;
      case "Difensore": return POSITION_DEFENDER;
      case "Portiere": return POSITION_GOALKEEPER;
      default: return 0;
    }
  }

  Team getTeam() {
    Team team = Team();
    team.id = teamId;
    team.name = teamName;
    return team;
  }

  Category getCategory() {
    Category category = Category();
    category.id = categoryId;
    category.name = categoryName;
    return category;
  }

  void setTeam(Team team) {
    teamId = team.id;
    teamName = team.name;
  }

  void setCategory(Category category) {
    categoryId = category.id;
    categoryName = category.name;
  }

  void checkRequiredFields() {
    Preconditions.requireFieldNotNull("id", id);
    Preconditions.requireFieldNotNull("name", name);
    Preconditions.requireFieldNotNull("surname", surname);
    Preconditions.requireFieldNotNull("teamId", teamId);
    Preconditions.requireFieldNotNull("categoryId", categoryId);
  }

}