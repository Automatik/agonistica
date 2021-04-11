import 'package:agonistica/core/models/season.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class SeasonRepository extends CrudRepository<Season> {

  SeasonRepository(DatabaseReference databaseReference)
    : super(databaseReference, DatabaseService.firebaseSeasonsChild);

  // SET

  Future<void> saveSeason(Season season) async {
    await super.saveItem(season);
  }

  // GET

  Future<Season> getSeasonById(String seasonId) async {
    return await super.getItemById(seasonId);
  }

  Future<List<Season>> getSeasonsByIds(List<String> seasonsIds) async {
    return await super.getItemsByIds(seasonsIds);
  }

  @override
  Map<String, dynamic> itemToJson(Season t) {
    return t.toJson();
  }

  @override
  Season jsonToItem(Map<dynamic, dynamic> json) {
    return Season.fromJson(json);
  }

  @override
  String getItemId(Season item) {
    return item.id;
  }

}