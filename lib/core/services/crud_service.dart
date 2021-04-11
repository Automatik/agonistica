import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class CrudService<T> {

  static Logger logger = getLogger('CrudService');

  CrudRepository<T> repository;

  CrudService(CrudRepository<T> repository) {
    this.repository = repository;
  }

  Future<void> saveItem(T item) async {
    repository.sa
  }


}