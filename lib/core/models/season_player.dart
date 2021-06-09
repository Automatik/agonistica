import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/match_player_data.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/player_match_notes.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/utils/db_utils.dart';
import 'package:logger/logger.dart';

class SeasonPlayer {

  static const int POSITION_FORWARD = 0;
  static const int POSITION_MIDFIELDER = 1;
  static const int POSITION_DEFENDER = 2;
  static const int POSITION_GOALKEEPER = 3;

  static const int MIN_VALUE = 1;
  static const int MAX_VALUE = 10;

  static Logger _logger = getLogger('SeasonPlayer');

  String? id;
  String? playerId;
  String? seasonTeamId;
  String? seasonId;
  String? categoryId;
  List<String?>? matchesIds;
  List<String?>? playerMatchNotesIds;

  int? height;
  int? weight;
  int? position;

  // Player's stats
  int? matches, goals, yellowCards, redCards;

  //Player's characteristics
  int? tecnica, agonistica, fisica, tattica, capMotorie;

  //Player's conditional capacities
  int? velocita, rapidita, scatto, resistenza, corsa, progressione, cambioPasso, elevazione;

  String? morfologia, sommatoTipo;

  String? attitudine1, attitudine2, attitudine3;

  // Only temporary, do not store
  SeasonTeam? seasonTeam;
  String? categoryName;
  Player? player;
  List<PlayerMatchNotes>? playerMatchesNotes;

  SeasonPlayer() {
    id = DbUtils.newUuid();
  }

  SeasonPlayer.empty(String playerId, String seasonTeamId, String seasonId, String categoryId) {
    Preconditions.requireArgumentNotEmpty(playerId);
    Preconditions.requireArgumentNotEmpty(seasonTeamId);
    Preconditions.requireArgumentNotEmpty(seasonId);
    Preconditions.requireArgumentNotEmpty(categoryId);

    id = DbUtils.newUuid();
    this.playerId = playerId;
    this.seasonTeamId = seasonTeamId;
    this.seasonId = seasonId;
    this.categoryId = categoryId;
    matchesIds = List.empty();
    playerMatchNotesIds = List.empty();

    height = 0;
    weight = 0;
    position = POSITION_MIDFIELDER;

    resetStats();

    tecnica = agonistica = fisica = tattica = capMotorie = MIN_VALUE;

    velocita = rapidita = scatto = resistenza = corsa = progressione = cambioPasso = elevazione = MIN_VALUE;

    morfologia = sommatoTipo = "";

    attitudine1 = attitudine2 = attitudine3 = "";
  }

  /// Useful constructor to create both a new Player and a new SeasonPlayer
  /// with all the temporary objects populated
  factory SeasonPlayer.newPlayer(SeasonTeam seasonTeam, Category category) {
    Preconditions.requireArgumentNotNull(seasonTeam);
    Preconditions.requireArgumentNotNull(category);

    // New Empty Player
    Player player = Player.empty();
    // Create new empty SeasonPlayer
    SeasonPlayer seasonPlayer = SeasonPlayer.empty(player.id!, seasonTeam.id!, seasonTeam.seasonId!, category.id!);
    // Set temporary values
    seasonPlayer.setCategory(category);
    seasonPlayer.setSeasonTeam(seasonTeam);
    seasonPlayer.player = player;
    return seasonPlayer;
  }

  SeasonPlayer.clone(SeasonPlayer sp) {
    id = sp.id;
    playerId = sp.playerId;
    seasonTeamId = sp.seasonTeamId;
    seasonId = sp.seasonId;
    categoryId = sp.categoryId;
    matchesIds = List.from(sp.matchesIds ?? []);
    playerMatchNotesIds = List.from(sp.playerMatchNotesIds ?? []);

    height = sp.height;
    weight = sp.weight;
    position = sp.position;

    matches = sp.matches;
    goals = sp.goals;
    yellowCards = sp.yellowCards;
    redCards = sp.redCards;

    tecnica = sp.tecnica;
    agonistica = sp.agonistica;
    fisica = sp.fisica;
    tattica = sp.tattica;
    capMotorie = sp.capMotorie;

    velocita = sp.velocita;
    rapidita = sp.rapidita;
    scatto = sp.scatto;
    resistenza = sp.resistenza;
    corsa = sp.corsa;
    progressione = sp.progressione;
    cambioPasso = sp.cambioPasso;
    elevazione = sp.elevazione;

    morfologia = sp.morfologia;
    sommatoTipo = sp.sommatoTipo;

    attitudine1 = sp.attitudine1;
    attitudine2 = sp.attitudine2;
    attitudine3 = sp.attitudine3;

    //temporary
    seasonTeam = sp.seasonTeam;
    categoryName = sp.categoryName;
    player = sp.player;
  }

  static int compare(SeasonPlayer sp1, SeasonPlayer sp2) {
    String nm1 = sp1.player!.name! + " " + sp1.player!.surname!;
    String nm2 = sp2.player!.name! + " " + sp2.player!.surname!;
    return nm1.compareTo(nm2);
  }

  /// Reset stats before updating them by summing all the match player data
  void resetStats() {
    matches = goals = yellowCards = redCards = 0;
  }

  void updateFromMatch(MatchPlayerData playerData) {
    if(matches == null || goals == null || yellowCards == null || redCards == null) {
      return;
    }
    matches = matches! + 1;
    goals = goals! + playerData.numGoals!;
    yellowCards = yellowCards! + playerData.getYellowCardsCount();
    redCards = redCards! + playerData.getRedCardCount();
  }

  void addMatch(String? matchId) {
    matchesIds = DbUtils.addToListIfAbsent(matchesIds, matchId);
  }

  void addPlayerMatchNotesId(String? playerMatchNotesId) {
    playerMatchNotesIds = DbUtils.addToListIfAbsent(playerMatchNotesIds, playerMatchNotesId);
  }

  void removeMatch(String? matchId) {
    matchesIds = DbUtils.removeFromList(matchesIds, matchId);
  }

  void removePlayerMatchNotesId(String playerMatchNotesId) {
    playerMatchNotesIds = DbUtils.removeFromList(playerMatchNotesIds, playerMatchNotesId);
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'playerId': playerId,
      'seasonTeamId': seasonTeamId,
      'seasonId': seasonId,
      'categoryId': categoryId,
      'matchesIds': matchesIds,
      'playerMatchNotesIds': playerMatchNotesIds,
      'height': height,
      'weight': weight,
      'position': position,
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
      'attitudine3': attitudine3
    };
  }

  SeasonPlayer.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      playerId = json['playerId'],
      seasonTeamId = json['seasonTeamId'],
      seasonId = json['seasonId'],
      categoryId = json['categoryId'],
      matchesIds = json['matchesIds'] == null ? List.empty() : List<String>.from(json['matchesIds']),
      playerMatchNotesIds = json['playerMatchNotesIds'] == null ? List.empty(): List<String>.from(json['playerMatchNotesIds']),
      height = json['height'],
      weight = json['weight'],
      position = json['position'],
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
      attitudine3 = json['attitudine3'];

  String? getPlayerName() {
    _checkPlayerTempField();
    return player!.name;
  }

  String? getPlayerSurname() {
    _checkPlayerTempField();
    return player!.surname;
  }

  DateTime? getPlayerBirthday() {
    _checkPlayerTempField();
    return player!.birthDay;
  }

  bool? isRightHanded() {
    _checkPlayerTempField();
    return player!.isRightHanded;
  }

  SeasonTeam? getSeasonTeam() {
    _checkSeasonTeamTempField();
    return seasonTeam;
  }

  Category getCategory() {
    Category category = Category();
    category.id = categoryId;
    category.name = categoryName;
    return category;
  }

  void setSeasonTeam(SeasonTeam seasonTeam) {
    seasonTeamId = seasonTeam.id;
    this.seasonTeam = seasonTeam;
  }

  void setCategory(Category category) {
    categoryId = category.id;
    categoryName = category.name;
  }

  void setPlayerName(String name) {
    _checkPlayerTempField();
    player!.name = name;
  }

  void setPlayerSurname(String surname) {
    _checkPlayerTempField();
    player!.surname = surname;
  }

  void setPlayerBirthday(DateTime birthday) {
    _checkPlayerTempField();
    player!.birthDay = birthday;
  }

  void setIsRightHanded(bool isRightHanded) {
    _checkPlayerTempField();
    player!.isRightHanded = isRightHanded;
  }

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id!);
    Preconditions.requireFieldNotEmpty("playerId", playerId!);
    Preconditions.requireFieldNotEmpty("seasonTeamId", seasonTeamId!);
    Preconditions.requireFieldNotEmpty("seasonId", seasonId!);
    Preconditions.requireFieldNotEmpty("categoryId", categoryId!);
  }

  void _checkPlayerTempField() {
    Preconditions.requireFieldNotNull("player", player);
  }

  void _checkSeasonTeamTempField() {
    Preconditions.requireFieldNotNull("seasonTeam", seasonTeam);
  }

  static String positionToString(int? position) {
    switch(position) {
      case POSITION_FORWARD: return "Attaccante";
      case POSITION_MIDFIELDER: return "Centrocampista";
      case POSITION_DEFENDER: return "Difensore";
      case POSITION_GOALKEEPER: return "Portiere";
      default: return "N/A";
    }
  }

  static int stringToPosition(String? position) {
    switch(position) {
      case "Attaccante": return POSITION_FORWARD;
      case "Centrocampista": return POSITION_MIDFIELDER;
      case "Difensore": return POSITION_DEFENDER;
      case "Portiere": return POSITION_GOALKEEPER;
      default: return 0;
    }
  }

}