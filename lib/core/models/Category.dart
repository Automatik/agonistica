import 'package:uuid/uuid.dart';

class Category {

  String id;

  String name;

  List<String> matchesIds;
  List<String> playersIds;

  Category() {
    var uuid = Uuid();
    id = uuid.v4();
  }

  Map<String, dynamic> toJson() => {
    'id' : id,
    'name' : name,
    'matchesIds' : matchesIds,
    'playersIds' : playersIds
  };

  Category.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      name = json['name'],
      matchesIds = json['matchesIds'] == null ? List() : List<String>.from(json['matchesIds']),
      playersIds = json['playersIds'] == null ? List() : List<String>.from(json['playersIds']);

}