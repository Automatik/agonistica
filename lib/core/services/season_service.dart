import 'package:agonistica/core/exceptions/not_implemented_yet_exception.dart';
import 'package:agonistica/core/models/season.dart';
import 'package:agonistica/core/repositories/season_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:firebase_database/firebase_database.dart';

class SeasonService extends CrudService<Season> {

  SeasonService(DatabaseReference databaseReference)
    : super(databaseReference, SeasonRepository(databaseReference));

  @override
  Future<void> deleteItem(String itemId) async {
    throw NotImplementedYetException("Deleting a season means removing all items "
        "that belong to this season");
    // await super.deleteItem(itemId);
  }

}