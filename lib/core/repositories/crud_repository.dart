import 'package:agonistica/core/exceptions/integrity_exception.dart';
import 'package:agonistica/core/exceptions/not_found_exception.dart';
import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/logger.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

abstract class CrudRepository<T> {

  DatabaseReference databaseReference;
  String firebaseChild;

  static Logger logger = getLogger('CrudRepository');

  CrudRepository(DatabaseReference databaseReference, String firebaseChild) {
    this.databaseReference = databaseReference;
    this.firebaseChild = firebaseChild;
  }

  // SET

  /// Save item object in a key with value itemId
  Future<void> saveItem(T item) async {
    String itemId = getItemId(item);
    Preconditions.requireArgumentNotEmpty(itemId);

    final json = itemToJson(item);
    await databaseReference.child(firebaseChild).child(itemId).set(json);
  }

  // CHECK

  /// Return true if the item with id itemId exists
  Future<bool> itemExists(String itemId) async {
    Preconditions.requireArgumentNotEmpty(itemId);

    final DataSnapshot snapshot = await databaseReference.child(firebaseChild).child(itemId).once();
    bool itemExists = snapshot.value != null;
    return itemExists;
  }

  // GET

  /// Download the item object with the given id
  Future<T> getItemById(String itemId) async {
    Preconditions.requireArgumentNotEmpty(itemId);

    final DataSnapshot snapshot = await databaseReference.child(firebaseChild).child(itemId).once();
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
      final snapshot = await databaseReference.child(firebaseChild).child(itemId).once();
      if(snapshot.value == null) {
        throw NotFoundException("Item of class ${T.toString()} with id $itemId not found in database.");
      }
      items.add(jsonToItem(snapshot.value));
    }
    return items;
  }

  /// Download all items in firebase
  Future<List<T>> getAllItems() async {
    final DataSnapshot snapshot = await databaseReference.child(firebaseChild).once();
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

    await databaseReference.child(firebaseChild).child(itemId).remove();
  }

  Map<String, dynamic> itemToJson(T item);

  T jsonToItem(Map<dynamic, dynamic> json);

  String getItemId(T item);

}