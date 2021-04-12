import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/repositories/menu_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:firebase_database/firebase_database.dart';

class MenuService extends CrudService<Menu> {

  MenuService(DatabaseReference databaseReference)
    : super(databaseReference, MenuRepository(databaseReference));

}
