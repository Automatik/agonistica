// @dart=2.9

import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class Category {

  String id;

  String name;

  String imageFilename;

  Category() {
    id = DbUtils.newUuid();
  }

  Category.name(String name, String imageFilename) {
    id = DbUtils.newUuid();
    this.name = name;
    this.imageFilename = imageFilename;
  }

  static int compare(Category c1, Category c2) {
    return c1.name.compareTo(c2.name);
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'name': name,
      'imageFilename': imageFilename
    };
  }

  Category.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      name = json['name'],
      imageFilename = json['imageFilename'];

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("name", name);
  }

}