// @dart=2.9

import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class CrudService<T> {

  static Logger logger = getLogger('CrudService');

  final DatabaseReference databaseReference;

  CrudRepository<T> repository;

  CrudService(this.databaseReference, CrudRepository<T> repository) {
    this.repository = repository;
  }

  Future<void> saveItem(T item) async {
    await repository.saveItem(item);
  }

  Future<bool> itemExists(String itemId) async {
    return await repository.itemExists(itemId);
  }

  Future<T> getItemById(String itemId) async {
    return await repository.getItemById(itemId);
  }

  Future<List<T>> getItemsByIds(List<String> itemsIds) async {
    return await repository.getItemsByIds(itemsIds);
  }

  Future<List<T>> getAllItems() async {
    return await repository.getAllItems();
  }

  Future<void> deleteItem(String itemId) async {
    await repository.deleteItem(itemId);
  }


}