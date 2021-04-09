import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class Category {

  String id;

  String name;

  Category() {
    id = DbUtils.newUuid();
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'name': name
    };
  }

  Category.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      name = json['name'];

  void checkRequiredFields() {
    Preconditions.requireFieldNotNull("id", id);
    Preconditions.requireFieldNotNull("name", name);
  }

}