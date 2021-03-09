import 'package:agonistica/core/exceptions/field_exception.dart';
import 'package:agonistica/core/guards/preconditions.dart';
import 'package:uuid/uuid.dart';

class Category {

  String id;

  String name;

  Category() {
    var uuid = Uuid();
    id = uuid.v4();
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