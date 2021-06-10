

import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class MenuRepository extends CrudRepository<Menu> {

  MenuRepository(DatabaseReference databaseReference, String? firebaseUserId)
    : super(databaseReference, DatabaseService.firebaseMenusChild, firebaseUserId: firebaseUserId);
  
  @override
  Map<String, dynamic> itemToJson(Menu t) {
    return t.toJson();
  }

  @override
  Menu jsonToItem(Map<dynamic, dynamic> json) {
    return Menu.fromJson(json);
  }

  @override
  String getItemId(Menu item) {
    return item.id!;
  }

}