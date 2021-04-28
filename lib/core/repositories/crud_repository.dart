import 'package:agonistica/core/exceptions/integrity_exception.dart';
import 'package:agonistica/core/exceptions/not_found_exception.dart';
import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/repositories/base_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

abstract class CrudRepository<T> extends BaseRepository{

  static Logger logger = getLogger('CrudRepository');

  CrudRepository(DatabaseReference databaseReference, String firebaseChild, {String firebaseUserId})
    : super(databaseReference, firebaseChild, firebaseUserId: firebaseUserId);

  // SET

  /// Save item object in a key with value itemId
  Future<void> saveItem(T item) async {
    String itemId = getItemId(item);
    Preconditions.requireArgumentNotEmpty(itemId);

    final json = itemToJson(item);
    await setItem(itemId, json);
  }

  // CHECK

  /// Return true if the item with id itemId exists
  Future<bool> itemExists(String itemId) async {
    Preconditions.requireArgumentNotEmpty(itemId);

    final DataSnapshot snapshot = await getItem(itemId);
    bool itemExists = snapshot.value != null;
    return itemExists;
  }

  // GET

  /// Download the item object with the given id
  Future<T> getItemById(String itemId) async {
    Preconditions.requireArgumentNotEmpty(itemId);

    final DataSnapshot snapshot = await getItem(itemId);
    if(snapshot.value == null) {
      throw NotFoundException("Item of class ${T.toString()} with id $itemId not found in database.");
    }
    return jsonToItem(snapshot.value);
  }

  /// Download the items objects with the given ids
  Future<List<T>> getItemsByIds(List<String> itemsIds) async {
    Preconditions.requireArgumentsNotNulls(itemsIds);

    List<T> items = List();
    for(String itemId in itemsIds) {
      final snapshot = await getItem(itemId);
      if(snapshot.value == null) {
        throw NotFoundException("Item of class ${T.toString()} with id $itemId not found in database.");
      }
      items.add(jsonToItem(snapshot.value));
    }
    return items;
  }

  /// Download all items in firebase
  Future<List<T>> getAllItems() async {
    final DataSnapshot snapshot = await getItems();
    List<T> items = [];
    Map<dynamic, dynamic> values = snapshot.value;
    if(values != null) {
      values.forEach((key, value) => items.add(jsonToItem(value)));
    }
    return items;
  }

  // DELETE

  /// Delete the item object with key itemId
  Future<void> deleteItem(String itemId) async {
    Preconditions.requireArgumentNotEmpty(itemId);

    await removeItem(itemId);
  }

  Map<String, dynamic> itemToJson(T item);

  T jsonToItem(Map<dynamic, dynamic> json);

  String getItemId(T item);

}