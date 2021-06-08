// @dart=2.9

import 'package:firebase_database/firebase_database.dart';

class BaseRepository {

  DatabaseReference databaseReference;
  String firebaseChild;
  String firebaseUserId;

  BaseRepository(DatabaseReference databaseReference, String firebaseChild, {String firebaseUserId}) {
    this.databaseReference = databaseReference;
    this.firebaseChild = firebaseChild;
    this.firebaseUserId = firebaseUserId;
  }

  bool useFirebaseUserChild() {
    return firebaseUserId != null;
  }

  Future<void> setItem(String itemId, Map<String, dynamic> json) async {
    if(useFirebaseUserChild()) {
      await databaseReference.child(firebaseChild).child(firebaseUserId).child(itemId).set(json);
    } else {
      await databaseReference.child(firebaseChild).child(itemId).set(json);
    }
  }

  Future<DataSnapshot> getItem(String itemId) async {
    if(useFirebaseUserChild()) {
      return await databaseReference.child(firebaseChild).child(firebaseUserId).child(itemId).once();
    } else {
      return await databaseReference.child(firebaseChild).child(itemId).once();
    }
  }

  Future<DataSnapshot> getItems() async {
    if(useFirebaseUserChild()) {
      return await databaseReference.child(firebaseChild).child(firebaseUserId).once();
    } else {
      return await databaseReference.child(firebaseChild).once();
    }
  }

  Future<void> removeItem(String itemId) async {
    if(useFirebaseUserChild()) {
      return await databaseReference.child(firebaseChild).child(firebaseUserId).child(itemId).remove();
    } else {
      return await databaseReference.child(firebaseChild).child(itemId).remove();
    }
  }

}