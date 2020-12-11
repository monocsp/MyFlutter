import 'package:cloud_firestore/cloud_firestore.dart';

class CakeData {
  final List<String> cakeSize;
  final List<String> cakePrice;
  CakeData({this.cakeSize, this.cakePrice});

  factory CakeData.fromMap(Map map) {
    Map _getCakeData = map["CakePrice"];
    return CakeData(
        cakeSize: _getCakeData.keys ?? [],
        cakePrice: _getCakeData.values ?? []);
  }
  factory CakeData.fromFireStore(DocumentSnapshot doc) {
    Map map = doc.data()["CakePrice"];
    return CakeData(cakeSize: map.keys ?? [], cakePrice: map.values ?? []);
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
