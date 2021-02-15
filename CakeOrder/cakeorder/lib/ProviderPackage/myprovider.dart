import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'cakeDataClass.dart';

class SetProvider {
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

  Stream<List<CakeData>> getCakeData() {
    return _db.collection("Cake").snapshots().map(
        (list) => list.docs.map((doc) => CakeData.fromFireStore(doc)).toList());
  }

  Stream<List<CakeDataOrder>> getTodayOrderCakeData() {
    var today = new DateTime.now();
    DateTime _todayStart =
        new DateTime(today.year, today.month, today.day, 0, 0);
    DateTime _todayEnd =
        new DateTime(today.year, today.month, today.day, 23, 59, 59);
    return _db
        .collection("Cake")
        .where("orderDate", isGreaterThanOrEqualTo: _todayStart)
        .where("orderDate", isLessThanOrEqualTo: _todayEnd)
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => CakeDataOrder.fromFireStore(doc)).toList()
              ..sort((a, b) => a.pickUpDate.compareTo(b.pickUpDate)));
  }

  Stream<List<CakeDataPickUp>> getTodayPickCupCakeData() {
    var today = new DateTime.now();
    DateTime _todayStart =
        new DateTime(today.year, today.month, today.day, 0, 0);
    DateTime _todayEnd =
        new DateTime(today.year, today.month, today.day, 23, 59, 59);

    return _db
        .collection("Cake")
        .where("pickUpDate",
            isGreaterThanOrEqualTo: _todayStart, isLessThanOrEqualTo: _todayEnd)
        // .where("pickUpStatus", isEqualTo: false)
        .orderBy("pickUpDate")
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => CakeDataPickUp.fromFireStore(doc)).toList()
              ..sort((a, b) {
                if (a.pickUpStatus) return 1;
                return -1;
              }));
  }

  Stream<List<CakeDataCalendarPickUp>> getCalendarPickUpCakeData() {
    var today = new DateTime.now();
    DateTime _monthStart = new DateTime(today.year, today.month - 3);
    DateTime _monthEnd = new DateTime(today.year, today.month + 3, 0);
    return _db
        .collection("Cake")
        .where("pickUpDate", isGreaterThanOrEqualTo: _monthStart)
        .where("pickUpDate", isLessThanOrEqualTo: _monthEnd)
        .orderBy("pickUpDate")
        .snapshots()
        .map((list) => list.docs
            .map((doc) => CakeDataCalendarPickUp.fromFireStore(doc))
            .toList());
  }

  Stream<List<CakeDataCalendarOrder>> getCalendarOrderCakeData() {
    var today = new DateTime.now();
    DateTime _monthStart = new DateTime(today.year, today.month - 3);
    DateTime _monthEnd = new DateTime(today.year, today.month + 3, 0);
    return _db
        .collection("Cake")
        .where("orderDate", isGreaterThanOrEqualTo: _monthStart)
        .where("orderDate", isLessThanOrEqualTo: _monthEnd)
        .orderBy("orderDate")
        .snapshots()
        .map((list) => list.docs
            .map((doc) => CakeDataCalendarOrder.fromFireStore(doc))
            .toList());
  }
}
