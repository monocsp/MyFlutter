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
        .orderBy("orderDate")
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => CakeDataOrder.fromFireStore(doc)).toList());
  }

  Stream<List<CakeDataPickUp>> getTodayPickCupCakeData() {
    var today = new DateTime.now();
    DateTime _todayStart =
        new DateTime(today.year, today.month, today.day, 0, 0);
    DateTime _todayEnd =
        new DateTime(today.year, today.month, today.day, 23, 59, 59);
    return _db
        .collection("Cake")
        .where("pickUpDate", isGreaterThanOrEqualTo: _todayStart)
        .where("pickUpDate", isLessThanOrEqualTo: _todayEnd)
        .orderBy("pickUpDate")
        .snapshots()
        .map((list) =>
            list.docs.map((doc) => CakeDataPickUp.fromFireStore(doc)).toList());
  }

  Stream<List<CakeDataCalendar>> getThisMonthCakeData() {
    var today = new DateTime.now();
    DateTime _monthStart = new DateTime(today.year, today.month);
    DateTime _monthEnd = new DateTime(today.year, today.month + 1, 0);
    return _db
        .collection("Cake")
        // .where("pickUpDate", isGreaterThanOrEqualTo: _monthStart)
        // .where("pickUpDate", isLessThanOrEqualTo: _monthEnd)
        .orderBy("pickUpDate")
        .snapshots()
        .map((list) => list.docs
            .map((doc) => CakeDataCalendar.fromFireStore(doc))
            .toList());
  }
}
