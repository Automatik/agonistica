import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/date_utils.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class Player {

  String id;
  String name, surname;

  DateTime birthDay;
  bool isRightHanded;


  Player() {
    id = DbUtils.newUuid();
  }

  Player.empty() {
    id = DbUtils.newUuid();
    name = "Nome";
    surname = "Cognome";
    birthDay = DateTime.utc(2020, 1, 1);
    isRightHanded = true;
  }

  Player.clone(Player p) {
    id = p.id;
    name = p.name;
    surname = p.surname;
    birthDay = DateUtils.fromDateTime(p.birthDay);
    isRightHanded = p.isRightHanded;
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'name': name,
      'surname': surname,
      'birthDay': birthDay.toIso8601String(),
      'isRightHanded': isRightHanded,
    };
  }

  Player.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      name = json['name'],
      surname = json['surname'],
      birthDay = DateTime.tryParse(json['birthDay']),
      isRightHanded = json['isRightHanded'];

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("name", name);
    Preconditions.requireFieldNotEmpty("surname", surname);
  }

}