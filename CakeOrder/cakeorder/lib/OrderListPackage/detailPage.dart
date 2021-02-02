import 'package:cakeorder/ProviderPackage/cakeDataClass.dart';
import 'package:flutter/material.dart';
import 'package:cakeorder/addOrderPackage/addOrder.dart';

class DetailPage extends StatefulWidget {
  final CakeData cakeData;
  DetailPage({Key key, this.cakeData}) : super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends AddOrderParent<DetailPage> {
  CakeData _cakeData;
  @override
  void initState() {
    _cakeData = widget.cakeData;
    super.initState();
  }

  @override
  setInitData() {
    isDetailPage = true;
    orderDate = _cakeData.orderDate.toString().split(' ')[0] ?? "";
    orderTime =
        _cakeData.orderDate.toString().split(' ')[1].split('.')[0] ?? "";
    pickUpDate = _cakeData.pickUpDate.toString().split(' ')[0] ?? "";
    pickUpTime =
        _cakeData.pickUpDate.toString().split(' ')[1].split('.')[0] ?? "";
    partTimer = _cakeData.partTimer;
    orderName = _cakeData.customerName;
    orderPhone = _cakeData.customerPhone;
    remarkText = _cakeData.remark;
    payStatus = _cakeData.payStatus;
    pickUpStatus = _cakeData.pickUpStatus;
    aboutCakeText =
        "${_cakeData.cakeCategory} ${_cakeData.cakeSize} X ${_cakeData.cakeCount}개";
  }

  @override
  Widget build(BuildContext context) {
    print(widget.cakeData.runtimeType);
    return super.build(context);
  }
}
