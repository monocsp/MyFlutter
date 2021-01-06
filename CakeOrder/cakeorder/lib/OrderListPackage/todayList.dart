import 'package:cloud_firestore/cloud_firestore.dart';
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

class _AddOrderState extends _TodayParent<OrderPage> {
  @override
  setListData() => Provider.of<List<CakeDataOrder>>(context);
}

class PickUpPage extends StatefulWidget {
  @override
  _PickUpPageState createState() => _PickUpPageState();
  // State createState() => new MyAppState();

}

class _PickUpPageState extends _TodayParent<PickUpPage> {
  @override
  setListData() => Provider.of<List<CakeDataPickUp>>(context);

  @override
  listViewSecondRow(int index) {
    return Container(
        margin: EdgeInsets.all(3),
        child: Row(children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 20,
          ),
          Icon(
            _listData[index].pickUpStatus ? Icons.check : Icons.close,
            color: Colors.redAccent,
            size: 18,
          )
        ]));
  }

  @override
  setSlidableDrawerActionPane(int index) {
    SnackBar snackbar = SnackBar(
      content: Text('픽업 완료!'),
      action: SnackBarAction(
        label: '취소',
        onPressed: () {
          _firestoreDataUpdate(_listData[index], isUndo: true);
        },
      ),
    );
    return SlidableDismissal(
      child: SlidableDrawerDismissal(
        key: UniqueKey(),
      ),
      onDismissed: (actionType) {
        setState(() {
          _firestoreDataUpdate(_listData[index], isUndo: false);
          _listData.remove(_listData[index]);
        });

        Scaffold.of(context).showSnackBar(snackbar);
      },
    );
    // return super.setSlidableDrawerActionPane();
  }

  Future _firestoreDataUpdate(CakeData cakeData,
      {@required bool isUndo}) async {
    FirebaseFirestore.instance
        .collection("Cake")
        .doc(cakeData.documentId)
        .update({"pickUpStatus": !isUndo ? true : false});
  }
}

abstract class _TodayParent<T extends StatefulWidget> extends State<T> {
  List<CakeData> _listData;
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

  setSlidableDrawerActionPane(int index) {
    return SlidableDismissal(
      child: SlidableDrawerDismissal(),
    );
  }

  setListData();
  @override
  Widget build(BuildContext context) {
    _listData = setListData();

    return _listData != null
        ? _listData.length != 0
            ? Container(
                margin: EdgeInsets.only(top: 5),
                child: ListView.builder(
                  itemCount: _listData.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      key: ValueKey(index),
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: customSwipeIconWidget(),
                      dismissal: setSlidableDrawerActionPane(index),
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
                                listViewFirstRow(index),
                                listViewSecondRow(index),
                                listViewThirdRow(index)
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

  List<Widget> customSwipeIconWidget() {
    return [
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
    ];
  }

  listViewFirstRow(int index) {
    int _totalPrice = _listData[index].cakePrice * _listData[index].cakeCount;
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
            _listData[index].cakeCategory +
                _listData[index].cakeSize +
                " X" +
                _listData[index].cakeCount.toString(),
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

  listViewSecondRow(int index) {
    return Container(
        margin: EdgeInsets.all(3),
        child: Row(children: [
          Icon(
            Icons.payment,
            size: 20,
          ),
          Icon(
            _listData[index].payStatus ? Icons.check : Icons.close,
            color: Colors.redAccent,
            size: 18,
          )
        ]));
  }

  listViewThirdRow(int index) {
    var _orderDateData =
        _listData[index].orderDate.add(Duration(hours: 9)).toString().split('');
    var _pickUpDateData = _listData[index]
        .pickUpDate
        .add(Duration(hours: 9))
        .toString()
        .split('');

    int _dateLength = _listData[index].orderDate.toString().split('').length;

    _orderDateData.removeRange(_dateLength - 7, _dateLength);
    _pickUpDateData.removeRange(_dateLength - 7, _dateLength);

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
            _listData[index].partTimer + "  " + _orderDateData.join(),
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ]));
  }
}
