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
class CakeDataError {
  final String errorName;
  final String errorComment;
  CakeDataError({this.errorName, this.errorComment});
}

class CakeSizePrice {
  final String cakeSize;
  final int cakePrice;
  const CakeSizePrice(this.cakeSize, this.cakePrice);
}

class CakeData {
  DateFormat f = DateFormat("yyyy-MM-dd hh:mm");
  var orderDate;
  var pickUpDate;
  final String cakeCategory;
  final String cakeSize;
  final int cakePrice;
  final String customerName;
  final String customerPhone;
  final String partTimer;
  final String remark;
  final bool paystatus;
  final bool pickUpStatus;
  final int cakeCount;

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
      this.documentId,
      this.cakeCount});

  Future toFireStore(callback) async {
    this.orderDate = Timestamp.fromDate(f.parse(orderDate));
    this.pickUpDate = Timestamp.fromDate(f.parse(pickUpDate));
    await FirebaseFirestore.instance.collection("Cake").add({
      "orderDate": orderDate,
      "pickUpDate": pickUpDate,
      "cakeCategory": cakeCategory,
      "cakeSize": cakeSize,
      "cakePrice": cakePrice,
      "customerName": customerName,
      "customerPhone": customerPhone,
      "partTimer": partTimer,
      "remark": remark,
      "payStatus": paystatus ?? false,
      "pickUpStatus": pickUpStatus ?? false,
      "cakeCount": cakeCount
    }).then((value) {
      this.documentId = value.id;
      callback();
    });
  }

  forRead() {
    this.orderDate = orderDate.toDate();
    this.pickUpDate = pickUpDate.toDate();
  }

  factory CakeData.fromFireStore(DocumentSnapshot snapshot) {
    print(snapshot.id);
    var _cakeData = snapshot.data();
    return CakeData(
      cakeCategory: _cakeData["cakeCategory"],
      cakeCount: _cakeData["cakeCount"],
      cakePrice: _cakeData["cakePrice"],
      cakeSize: _cakeData["cakeSize"],
      customerName: _cakeData["customerName"],
      customerPhone: _cakeData["customerPhone"],
      documentId: snapshot.id,
      orderDate: _cakeData["orderDate"],
      partTimer: _cakeData["partTimer"],
      paystatus: _cakeData["paystatus"],
      pickUpDate: _cakeData["pickUpDate"],
      pickUpStatus: _cakeData["pickUpStatus"],
      remark: _cakeData["remark"],
    );
  }
}

class CakeCategory {
  final String name;
  final List<dynamic> cakeSize;
  final List<dynamic> cakePrice;
  CakeCategory({this.name, this.cakePrice, this.cakeSize});
  factory CakeCategory.fromFireStore(DocumentSnapshot snapshot) {
    var _data = snapshot.data()["CakePrice"];
    return CakeCategory(
        name: snapshot.id ?? '',
        cakeSize: _data.keys.toList() ?? [],
        cakePrice: _data.values.toList() ?? []);
  }
}
