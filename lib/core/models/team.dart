import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class Team {

  String id;

  String name;

  Team() {
    id = DbUtils.newUuid();
  }

  Team.name(String name) {
    id = DbUtils.newUuid();
    this.name = name;
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'name': name,
    };
  }

  Team.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'];

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("name", name);
  }

}