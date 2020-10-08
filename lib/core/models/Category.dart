import 'package:uuid/uuid.dart';

class Category {

  String id;

  String name;

  Category() {
    var uuid = Uuid();
    id = uuid.v4();
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name
  };

  Category.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      name = json['name'];
}