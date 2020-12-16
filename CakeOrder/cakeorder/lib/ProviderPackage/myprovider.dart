import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'cakeList.dart';

class DatabaseProvider {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<dynamic>> getPartTimer() {
    return _db
        .collection("PartTimer")
        .doc("partTimerDoc")
        .snapshots()
        .map((list) => list.data()["PartTimerList"]);
  }

  Stream<List<CakeCategory>> getCakeCategory() {
    return _db.collection("CakeList").snapshots().map((list) =>
        list.docs.map((doc) => CakeCategory.fromFireStore(doc)).toList());
  }
  Stream<List<CakeData>> getTodayOrderCakeData(){
    return _db.collection(collectionPath)
  }
  // Stream<List<CakeData>> getTodayPickUpCakeData(){
  //   return _db.collection(collectionPath)
  // }
}
