import 'package:agonistica/core/exceptions/integrity_exception.dart';
import 'package:agonistica/core/exceptions/not_implemented_yet_exception.dart';
import 'package:agonistica/core/models/season.dart';
import 'package:agonistica/core/repositories/season_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:firebase_database/firebase_database.dart';

class SeasonService extends CrudService<Season> {

  SeasonService(DatabaseReference databaseReference)
    : super(databaseReference, SeasonRepository(databaseReference));

  @override
  Future<void> saveItem(Season item) async {
    bool seasonExists = await itemWithGivenYearsExists(item.beginYear, item.endYear);
    if(seasonExists) {
      throw IntegrityException("Season with beginYear ${item.beginYear} and "
          "endYear ${item.endYear} already exists");
    }
    await super.saveItem(item);
  }

  Future<bool> itemWithGivenYearsExists(int beginYear, int endYear) async {
    List<Season> seasons = await getAllItems();
    return seasons.any((s) => s.beginYear == beginYear && s.endYear == endYear);
  }

  @override
  Future<void> deleteItem(String itemId) async {
    throw NotImplementedYetException("Deleting a season means removing all items "
        "that belong to this season");
    // await super.deleteItem(itemId);
  }

}