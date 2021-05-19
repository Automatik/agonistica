import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/exceptions/integrity_exception.dart';
import 'package:agonistica/core/exceptions/not_implemented_yet_exception.dart';
import 'package:agonistica/core/models/season.dart';
import 'package:agonistica/core/repositories/season_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:firebase_database/firebase_database.dart';

class SeasonService extends CrudService<Season> {

  SeasonService(DatabaseReference databaseReference)
    : super(databaseReference, SeasonRepository(databaseReference, locator<AppStateService>().selectedAppUser.id));

  @override
  Future<void> saveItem(Season item) async {
    bool seasonExists = await itemWithGivenYearsExists(item.beginYear, item.endYear);
    if(seasonExists) {
      throw IntegrityException("Season with beginYear ${item.beginYear} and "
          "endYear ${item.endYear} already exists");
    }
    await super.saveItem(item);
  }

  Future<Season> getCurrentSeason() async {
    Season currentSeason = Season.createCurrentSeason();
    List<Season> seasons = await getAllItems();
    int index = seasons.indexWhere((s) => s.beginYear == currentSeason.beginYear && s.endYear == currentSeason.endYear);
    if(index == -1) {
      CrudService.logger.d("No current season created yet.");
      // Save current season
      await saveItem(currentSeason);
      return currentSeason;
    }
    return seasons[index];
  }

  Future<bool> itemWithGivenYearsExists(int beginYear, int endYear) async {
    List<Season> seasons = await getAllItems();
    return seasons.any((s) => s.beginYear == beginYear && s.endYear == endYear);
  }

  Future<List<Season>> getUniqueSeasonsFromIds(List<String> seasonsIds) async {
    Set<String> uniqueSeasonsIds = Set.of(seasonsIds);
    return await getItemsByIds(uniqueSeasonsIds.toList());
  }

  @override
  Future<void> deleteItem(String itemId) async {
    throw NotImplementedYetException("Deleting a season means removing all items "
        "that belong to this season");
    // await super.deleteItem(itemId);
  }

}