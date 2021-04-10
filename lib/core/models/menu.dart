import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class Menu {

  static const int TYPE_FOLLOWED_TEAMS = 0;
  static const int TYPE_FOLLOWED_PLAYERS = 1;

  String id;

  String name;

  int type;

  List<String> categoriesIds;

  Menu() {
    id = DbUtils.newUuid();
  }

  Menu.create(String name, int type) {
    Preconditions.requireArgumentNotEmpty(name);
    Preconditions.requireArgumentGreaterThan(type, TYPE_FOLLOWED_TEAMS - 1);
    Preconditions.requireArgumentLessThan(type, TYPE_FOLLOWED_PLAYERS + 1);

    id = DbUtils.newUuid();
    this.name = name;
    this.type = type;
    categoriesIds = List();
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'name': name,
      'type': type,
      'categoriesIds': categoriesIds
    };
  }

  Menu.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      name = json['name'],
      type = json['type'],
      categoriesIds = json['categoriesIds'] == null ? List() : List<String>.from(json['categoriesIds']);

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("name", name);
    Preconditions.requireFieldGreaterThan("type", type, TYPE_FOLLOWED_TEAMS - 1);
    Preconditions.requireFieldLessThan("type", type, TYPE_FOLLOWED_PLAYERS + 1);
  }

}