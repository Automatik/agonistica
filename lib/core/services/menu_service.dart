import 'package:agonistica/core/exceptions/not_implemented_yet_exception.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/repositories/menu_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:firebase_database/firebase_database.dart';

class MenuService extends CrudService<Menu> {

  MenuService(DatabaseReference databaseReference)
    : super(databaseReference, MenuRepository(databaseReference));

  @override
  Future<void> deleteItem(String itemId) async {
    throw NotImplementedYetException("Still need to think of consequences");
    // await super.deleteItem(itemId);
  }

}
