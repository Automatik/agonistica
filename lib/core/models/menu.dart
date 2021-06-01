import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class Menu {

  static const int TYPE_FOLLOWED_TEAMS = 0;
  static const int TYPE_FOLLOWED_PLAYERS = 1;

  String id;

  String name;

  int type;

  String imageFilename;

  String teamId;
  List<String> categoriesIds;

  Menu() {
    id = DbUtils.newUuid();
  }

  Menu._create(String name, int type, String imageFilename) {
    Preconditions.requireArgumentNotEmpty(name);
    Preconditions.requireArgumentGreaterThan(type, TYPE_FOLLOWED_TEAMS - 1);
    Preconditions.requireArgumentLessThan(type, TYPE_FOLLOWED_PLAYERS + 1);
    Preconditions.requireArgumentNotEmpty(imageFilename);

    id = DbUtils.newUuid();
    this.name = name;
    this.type = type;
    this.imageFilename = imageFilename;
  }

  factory Menu.createTeamMenu(String name, String teamId, String imageFilename) {
    Preconditions.requireArgumentNotEmpty(teamId);

    Menu menu = Menu._create(name, TYPE_FOLLOWED_TEAMS, imageFilename);
    menu.teamId = teamId;
    return menu;
  }

  factory Menu.createPlayersMenu(String name, List<String> categoriesIds, String imageFilename) {
    Preconditions.requireArgumentsNotNulls(categoriesIds);

    Menu menu = Menu._create(name, TYPE_FOLLOWED_PLAYERS, imageFilename);
    menu.categoriesIds = categoriesIds;
    return menu;
  }

  void addCategory(String categoryId) {
    categoriesIds = DbUtils.addToListIfAbsent(categoriesIds, categoryId);
  }

  void removeCategory(String categoryId) {
    categoriesIds = DbUtils.removeFromList(categoriesIds, categoryId);
  }

  bool isTeamMenu() {
    return type == TYPE_FOLLOWED_TEAMS;
  }

  bool isPlayersMenu() {
    return type == TYPE_FOLLOWED_PLAYERS;
  }

  static int compare(Menu m1, Menu m2) {
    return m1.name.compareTo(m2.name);
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'name': name,
      'type': type,
      'teamId': teamId,
      'categoriesIds': categoriesIds,
      'imageFilename': imageFilename
    };
  }

  Menu.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      name = json['name'],
      type = json['type'],
      teamId = json['teamId'],
      categoriesIds = json['categoriesIds'] == null ? List() : List<String>.from(json['categoriesIds']),
      imageFilename = json['imageFilename'];

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("name", name);
    Preconditions.requireFieldGreaterThan("type", type, TYPE_FOLLOWED_TEAMS - 1);
    Preconditions.requireFieldLessThan("type", type, TYPE_FOLLOWED_PLAYERS + 1);
    if(isTeamMenu()) {
      Preconditions.requireFieldNotEmpty("teamId", teamId);
    } else {
      Preconditions.requireFieldsNotNulls("categoriesIds", categoriesIds);
    }
    Preconditions.requireFieldNotEmpty("imageFilename", imageFilename);
  }

}