import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class Menu {

  static const int TYPE_FOLLOWED_TEAMS = 0;
  static const int TYPE_FOLLOWED_PLAYERS = 1;

  String id;

  String name;

  int type;

  String teamId;
  List<String> categoriesIds;

  Menu() {
    id = DbUtils.newUuid();
  }

  Menu._create(String name, int type) {
    Preconditions.requireArgumentNotEmpty(name);
    Preconditions.requireArgumentGreaterThan(type, TYPE_FOLLOWED_TEAMS - 1);
    Preconditions.requireArgumentLessThan(type, TYPE_FOLLOWED_PLAYERS + 1);

    id = DbUtils.newUuid();
    this.name = name;
    this.type = type;
  }

  Menu.createTeamMenu(String name, int type, String teamId) {
    Preconditions.requireArgumentNotEmpty(teamId);

    Menu._create(name, type);
    this.teamId = teamId;
  }

  Menu.createPlayersMenu(String name, int type, List<String> categoriesIds) {
    Preconditions.requireArgumentsNotNulls(categoriesIds);

    Menu._create(name, type);
    this.categoriesIds = categoriesIds;
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'name': name,
      'type': type,
      'teamId': teamId,
      'categoriesIds': categoriesIds
    };
  }

  Menu.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      name = json['name'],
      type = json['type'],
      teamId = json['teamId'],
      categoriesIds = json['categoriesIds'] == null ? List() : List<String>.from(json['categoriesIds']);

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("name", name);
    Preconditions.requireFieldGreaterThan("type", type, TYPE_FOLLOWED_TEAMS - 1);
    Preconditions.requireFieldLessThan("type", type, TYPE_FOLLOWED_PLAYERS + 1);
    if(type == TYPE_FOLLOWED_TEAMS) {
      Preconditions.requireFieldNotEmpty("teamId", teamId);
    } else {
      Preconditions.requireFieldsNotNulls("categoriesIds", categoriesIds);
    }
  }

}