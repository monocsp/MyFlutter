import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cakeorder/addOrderPackage/AddOrder.dart';
// class CakeData {
//   final List<String> cakeSize;
//   final List<String> cakePrice;
//   CakeData({this.cakeSize, this.cakePrice});

//   factory CakeData.fromMap(Map map) {
//     Map _getCakeData = map["CakePrice"];
//     return CakeData(
//         cakeSize: _getCakeData.keys ?? [],
//         cakePrice: _getCakeData.values ?? []);
//   }
//   factory CakeData.fromFireStore(DocumentSnapshot doc) {
//     Map map = doc.data()["CakePrice"];
//     return CakeData(cakeSize: map.keys ?? [], cakePrice: map.values ?? []);
//   }
// }
class CakeSizePrice {
  final String cakeSize;
  final String cakePrice;
  const CakeSizePrice(this.cakeSize, this.cakePrice);
}

class CakeData {
  DateFormat f = DateFormat("yyyy-MM-dd hh:mm");
  var orderDate;
  var pickUpDate;
  final String cakeCategory;
  final String cakeSize;
  final String cakePrice;
  final String customerName;
  final String customerPhone;
  final String partTimer;
  final String remark;
  final bool paystatus;
  final bool pickUpStatus;

  String documentId;
  CakeData(
      {this.orderDate,
      this.pickUpDate,
      this.cakeCategory,
      this.cakeSize,
      this.customerName,
      this.cakePrice,
      this.customerPhone,
      this.partTimer,
      this.remark,
      this.paystatus,
      this.pickUpStatus,
      this.documentId});
  Future toFireStore(callback) async {
    this.orderDate = Timestamp.fromDate(f.parse(orderDate));
    this.pickUpDate = Timestamp.fromDate(f.parse(pickUpDate));
    await _storeFireStore();

    callback();
  }

//  c.toFireStore(loadDialogCallback);
  // var _id;
  // Map<dynamic, dynamic> temp = {
  //   "time": Timestamp.fromDate(f.parse(
  //       _textEditingControllerOrderDate.text +
  //           " " +
  //           _textEditingControllerOrderTime.text))
  // };
  // FirebaseFirestore.instance
  //     .collection("Cake")
  //     .add(temp.cast())
  //     .then((value) {
  //   _id = value.id;
  //   FirebaseFirestore.instance
  //       .collection("Cake")
  //       .doc(_id)
  //       .get()
  //       .then((value) => print(value.data()["time"].toDate()));
  // });
  // var a = DateFormat(_textEditingControllerOrderDate.text);
  _storeFireStore() {
    FirebaseFirestore.instance
        .collection("Cake")
        .add({"OrderDate": orderDate, "PickUpDate": pickUpDate}).then((value) {
      this.documentId = value.id;
    });
  }

  forRead() {
    this.orderDate = orderDate.toDate();
    this.pickUpDate = pickUpDate.toDate();
  }
}

class CakeCategory {
  final String name;
  final List<dynamic> cakeSize;
  final List<dynamic> cakePrice;
  CakeCategory({this.name, this.cakePrice, this.cakeSize});
  factory CakeCategory.fromFireStore(DocumentSnapshot snapshot) {
    var _cakePrice = snapshot.data()["CakePrice"];
    return CakeCategory(
        name: snapshot.id ?? '',
        cakeSize: _cakePrice.keys.toList() ?? [],
        cakePrice: _cakePrice.values.toList() ?? []);
  }
}
