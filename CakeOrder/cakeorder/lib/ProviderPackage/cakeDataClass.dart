import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:cakeorder/addOrderPackage/AddOrder.dart';

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
  final bool payStatus;
  final bool pickUpStatus;
  final int cakeCount;
  final bool decoStatus;

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
      this.payStatus,
      this.pickUpStatus,
      this.documentId,
      this.cakeCount,
      this.decoStatus});

  Future toFireStore(callback) async {
    this.orderDate =
        Timestamp.fromDate(f.parse(orderDate).subtract(Duration(hours: 9)));
    this.pickUpDate =
        Timestamp.fromDate(f.parse(pickUpDate).subtract(Duration(hours: 9)));
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
      "payStatus": payStatus ?? false,
      "pickUpStatus": pickUpStatus ?? false,
      "cakeCount": cakeCount,
      "decoStatus": decoStatus ?? false,
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
        cakeCategory: _cakeData["cakeCategory"] ?? '',
        cakeCount: _cakeData["cakeCount"] ?? 1,
        cakePrice: _cakeData["cakePrice"] ?? '',
        cakeSize: _cakeData["cakeSize"] ?? '',
        customerName: _cakeData["customerName"],
        customerPhone: _cakeData["customerPhone"],
        documentId: snapshot.id,
        orderDate: _cakeData["orderDate"].toDate(),
        partTimer: _cakeData["partTimer"] ?? '',
        payStatus: _cakeData["payStatus"] ?? false,
        pickUpDate: _cakeData["pickUpDate"].toDate(),
        pickUpStatus: _cakeData["pickUpStatus"] ?? false,
        remark: _cakeData["remark"] ?? '',
        decoStatus: _cakeData["decoStatus"] ?? false);
  }
}

class CakeDataOrder extends CakeData {
  CakeDataOrder(
      {var orderDate,
      var pickUpDate,
      String cakeCategory,
      String cakeSize,
      String customerName,
      int cakePrice,
      String customerPhone,
      String partTimer,
      String remark,
      bool payStatus,
      bool pickUpStatus,
      String documentId,
      int cakeCount,
      bool decoStatus})
      : super(
            cakeCategory: cakeCategory,
            cakeCount: cakeCount,
            cakePrice: cakePrice,
            cakeSize: cakeSize,
            customerName: customerName,
            customerPhone: customerPhone,
            decoStatus: decoStatus,
            documentId: documentId,
            orderDate: orderDate,
            partTimer: partTimer,
            payStatus: payStatus,
            pickUpDate: pickUpDate,
            pickUpStatus: pickUpStatus,
            remark: remark);

  factory CakeDataOrder.fromFireStore(DocumentSnapshot snapshot) {
    print(snapshot.id);
    var _cakeData = snapshot.data();
    return CakeDataOrder(
        cakeCategory: _cakeData["cakeCategory"] ?? '',
        cakeCount: _cakeData["cakeCount"] ?? 1,
        cakePrice: _cakeData["cakePrice"] ?? '',
        cakeSize: _cakeData["cakeSize"] ?? '',
        customerName: _cakeData["customerName"],
        customerPhone: _cakeData["customerPhone"],
        documentId: snapshot.id,
        orderDate: _cakeData["orderDate"].toDate(),
        partTimer: _cakeData["partTimer"] ?? '',
        payStatus: _cakeData["payStatus"] ?? false,
        pickUpDate: _cakeData["pickUpDate"].toDate(),
        pickUpStatus: _cakeData["pickUpStatus"] ?? false,
        remark: _cakeData["remark"] ?? '',
        decoStatus: _cakeData["decoStatus"] ?? false);
  }
}

class CakeDataPickUp extends CakeData {
  CakeDataPickUp(
      {var orderDate,
      var pickUpDate,
      String cakeCategory,
      String cakeSize,
      String customerName,
      int cakePrice,
      String customerPhone,
      String partTimer,
      String remark,
      bool payStatus,
      bool pickUpStatus,
      String documentId,
      int cakeCount,
      bool decoStatus})
      : super(
            cakeCategory: cakeCategory,
            cakeCount: cakeCount,
            cakePrice: cakePrice,
            cakeSize: cakeSize,
            customerName: customerName,
            customerPhone: customerPhone,
            decoStatus: decoStatus,
            documentId: documentId,
            orderDate: orderDate,
            partTimer: partTimer,
            payStatus: payStatus,
            pickUpDate: pickUpDate,
            pickUpStatus: pickUpStatus,
            remark: remark);

  factory CakeDataPickUp.fromFireStore(DocumentSnapshot snapshot) {
    var _cakeData = snapshot.data();
    return CakeDataPickUp(
        cakeCategory: _cakeData["cakeCategory"] ?? '',
        cakeCount: _cakeData["cakeCount"] ?? 1,
        cakePrice: _cakeData["cakePrice"] ?? '',
        cakeSize: _cakeData["cakeSize"] ?? '',
        customerName: _cakeData["customerName"],
        customerPhone: _cakeData["customerPhone"],
        documentId: snapshot.id,
        orderDate: _cakeData["orderDate"].toDate(),
        partTimer: _cakeData["partTimer"] ?? '',
        payStatus: _cakeData["payStatus"] ?? false,
        pickUpDate: _cakeData["pickUpDate"].toDate(),
        pickUpStatus: _cakeData["pickUpStatus"] ?? false,
        remark: _cakeData["remark"] ?? '',
        decoStatus: _cakeData["decoStatus"] ?? false);
  }
}

class CakeDataCalendar extends CakeData {
  CakeDataCalendar(
      {var orderDate,
      var pickUpDate,
      String cakeCategory,
      String cakeSize,
      String customerName,
      int cakePrice,
      String customerPhone,
      String partTimer,
      String remark,
      bool payStatus,
      bool pickUpStatus,
      String documentId,
      int cakeCount,
      bool decoStatus})
      : super(
            cakeCategory: cakeCategory,
            cakeCount: cakeCount,
            cakePrice: cakePrice,
            cakeSize: cakeSize,
            customerName: customerName,
            customerPhone: customerPhone,
            decoStatus: decoStatus,
            documentId: documentId,
            orderDate: orderDate,
            partTimer: partTimer,
            payStatus: payStatus,
            pickUpDate: pickUpDate,
            pickUpStatus: pickUpStatus,
            remark: remark);
  factory CakeDataCalendar.fromFireStore(DocumentSnapshot snapshot) {
    var _cakeData = snapshot.data();
    return CakeDataCalendar(
        cakeCategory: _cakeData["cakeCategory"] ?? '',
        cakeCount: _cakeData["cakeCount"] ?? 1,
        cakePrice: _cakeData["cakePrice"] ?? 1,
        cakeSize: _cakeData["cakeSize"] ?? '',
        documentId: snapshot.id,
        pickUpDate: _cakeData["pickUpDate"].toDate(),
        pickUpStatus: _cakeData["pickUpStatus"] ?? false);
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
