import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cakeorder/ProviderPackage/cakeDataClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class OrderPage extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
  // State createState() => new MyAppState();
}

class _AddOrderState extends State<OrderPage> {
  List<CakeDataOrder> _todayOrderList;
  SlidableController slidableController;
  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;
  @override
  void initState() {
    slidableController = SlidableController(
        onSlideAnimationChanged: handleSlideAnimationChanged,
        onSlideIsOpenChanged: handleSlideIsOpenChanged);
    super.initState();
  }

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    _todayOrderList = Provider.of<List<CakeDataOrder>>(context);

    return _todayOrderList != null
        ? _todayOrderList.length != 0
            ? Container(
                margin: EdgeInsets.only(top: 5),
                child: ListView.builder(
                  itemCount: _todayOrderList.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: ValueKey(index),
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'Update',
                          color: Colors.grey,
                          icon: Icons.edit,
                          closeOnTap: false,
                          onTap: () {
                            print('1');
                          },
                        ),
                        IconSlideAction(
                          caption: 'Delete',
                          color: Colors.redAccent,
                          icon: Icons.close,
                          closeOnTap: false,
                          onTap: () {
                            print('2');
                          },
                        )
                      ],
                      dismissal: SlidableDismissal(
                        child: SlidableDrawerDismissal(),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          print('hi + $index');
                        },
                        child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                border: Border.all(width: 1.0)),
                            height: 85,
                            child: Column(
                              children: [
                                _listViewFirstRow(index),
                                _listViewSecondRow(index),
                                _listViewThirdRow(index)
                              ],
                            )),
                      ),
                    );
                  },
                ),
              )
            : Center(
                child: Container(
                  child: Text("오늘 예약한 케이크가 없습니다."),
                ),
              )
        : Center(
            child: Container(child: CupertinoActivityIndicator()),
          );
  }

  _listViewFirstRow(int index) {
    int _totalPrice =
        _todayOrderList[index].cakePrice * _todayOrderList[index].cakeCount;
    List _addColon = _totalPrice.toString().split('');
    if (_addColon.length - 3 > 0 && _addColon.length != null) {
      int count = _addColon.length ~/ 3;
      int modulus = (_addColon.length - 3) % 3;
      for (int i = 0; i < count; i++) {
        if (i * 3 + modulus == 0) {
          continue;
        }
        _addColon.insert(i * 3 + modulus, ',');
      }
    }

    return Container(
        margin: EdgeInsets.all(3),
        child: Row(children: [
          Icon(
            Icons.cake_outlined,
            size: 20,
          ),
          Text(
            _todayOrderList[index].cakeCategory +
                _todayOrderList[index].cakeSize +
                " X" +
                _todayOrderList[index].cakeCount.toString(),
            style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
          Spacer(),
          Icon(Icons.money),
          Text(_addColon.join())
        ]));
  }

  _listViewSecondRow(int index) {
    return Container(
        margin: EdgeInsets.all(3),
        child: Row(children: [
          Icon(
            Icons.payment,
            size: 20,
          ),
          Icon(
            _todayOrderList[index].payStatus ? Icons.check : Icons.close,
            color: Colors.redAccent,
            size: 18,
          )
        ]));
  }

  _listViewThirdRow(int index) {
    var _orderDateData = _todayOrderList[index].orderDate.toString().split('');
    var _pickUpDateData =
        _todayOrderList[index].pickUpDate.toString().split('');
    int _dateLength =
        _todayOrderList[index].orderDate.toString().split('').length;

    _orderDateData.removeRange(_dateLength - 7, _dateLength);
    _pickUpDateData.removeRange(_dateLength - 7, _dateLength);
    // print(a.runtimeType);
    return Container(
        margin: EdgeInsets.only(top: 3, left: 3),
        child: Row(children: [
          Icon(
            Icons.event,
            size: 20,
          ),
          Text(
            _pickUpDateData.join(),
            style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 13),
          ),
          Spacer(),
          Icon(
            Icons.person,
            size: 15,
          ),
          Text(
            _todayOrderList[index].partTimer + "  " + _orderDateData.join(),
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ]));
  }
}
