import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/my_date_utils.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class Player {

  static const String EMPTY_PLAYER_NAME = "Nome";
  static const String EMPTY_PLAYER_SURNAME = "Surname";

  late String id;
  String? name, surname;

  DateTime? birthDay;
  bool? isRightHanded;

  List<String>? seasonPlayersIds;


  Player() {
    id = DbUtils.newUuid();
  }

  Player.empty() {
    id = DbUtils.newUuid();
    name = EMPTY_PLAYER_NAME;
    surname = EMPTY_PLAYER_SURNAME;
    birthDay = DateTime.utc(2020, 1, 1);
    isRightHanded = true;
    seasonPlayersIds = List.empty();
  }

  Player.clone(Player p) {
    id = p.id;
    name = p.name;
    surname = p.surname;
    birthDay = MyDateUtils.fromDateTime(p.birthDay!);
    isRightHanded = p.isRightHanded;
    seasonPlayersIds = p.seasonPlayersIds;
  }

  void addSeasonPlayer(String seasonPlayerId) {
    seasonPlayersIds = DbUtils.addToListIfAbsent(seasonPlayersIds, seasonPlayerId);
  }

  void removeSeasonPlayer(String seasonPlayerId) {
    seasonPlayersIds = DbUtils.removeFromList(seasonPlayersIds, seasonPlayerId);
  }

  bool hasEmptyName() {
    return isEmptyName(name);
  }

  bool hasEmptySurname() {
    return isEmptySurname(surname);
  }

  static bool isEmptyName(String? name) {
    return name == EMPTY_PLAYER_NAME;
  }

  static bool isEmptySurname(String? surname) {
    return surname == EMPTY_PLAYER_SURNAME;
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'name': name,
      'surname': surname,
      'birthDay': birthDay!.toIso8601String(),
      'isRightHanded': isRightHanded,
      'seasonPlayersIds': seasonPlayersIds
    };
  }

  Player.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      name = json['name'],
      surname = json['surname'],
      birthDay = DateTime.tryParse(json['birthDay']),
      isRightHanded = json['isRightHanded'],
      seasonPlayersIds = json['seasonPlayersIds'] == null ? List.empty(): List<String>.from(json['seasonPlayersIds']);

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("name", name!);
    Preconditions.requireFieldNotEmpty("surname", surname!);
  }

}