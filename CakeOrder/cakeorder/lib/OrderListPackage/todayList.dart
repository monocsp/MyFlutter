import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cakeorder/ProviderPackage/cakeDataClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/services.dart';

class OrderPage extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
  // State createState() => new MyAppState();
}

class _AddOrderState extends _TodayParent<OrderPage> {
  @override
  setListData() => Provider.of<List<CakeDataOrder>>(context);

  @override
  listViewSecondRow(int index) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 3, bottom: 3),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Row(
              children: [
                Icon(
                  Icons.payment,
                  size: 20,
                ),
                Icon(
                  _listData[index].payStatus ? Icons.check : Icons.close,
                  color: Colors.redAccent,
                  size: 18,
                ),
              ],
            ),
          ),
          Container(
            // width: MediaQuery.of(context).size.width / 2,
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  size: 15,
                ),
                Container(
                  child: Text(_listData[index].customerName),
                ),
              ],
            ),
          )
        ]));
  }

  @override
  List<Widget> customSwipeIconWidget(int index) {
    var _cakeData = _listData[index];
    return [
      IconSlideAction(
        caption: 'Delete!',
        color: Colors.redAccent,
        icon: Icons.delete,
        closeOnTap: false,
        onTap: () {
          setState(() {
            _firestoreDataUpdate(_cakeData, isUndo: false);
            _listData.remove(_cakeData);
          });
          Scaffold.of(context)
              .showSnackBar(_deleteSnackBar(_cakeData, index: index));
        },
      )
    ];
  }

  _deleteSnackBar(var cakeData, {int index}) {
    return SnackBar(
      content: Text('삭제 완료!'),
      action: SnackBarAction(
        label: '취소',
        textColor: Colors.redAccent,
        onPressed: () {
          setState(() {
            _firestoreDataUpdate(cakeData, isUndo: true);
            _listData.insert(index, cakeData);
          });
        },
      ),
    );
  }

  Future _firestoreDataUpdate(CakeData cakeData,
      {@required bool isUndo}) async {
    if (isUndo) {
      cakeData.unDoFireStore();
    } else {
      FirebaseFirestore.instance
          .collection("Cake")
          .doc(cakeData.documentId)
          .delete();
    }
  }

  @override
  setSlidableDrawerActionPane(int index) {
    // TODO: implement setSlidableDrawerActionPanevar _cakeData = _listData[index];
    var _cakeData = _listData[index];
    return SlidableDismissal(
      child: SlidableDrawerDismissal(
        key: UniqueKey(),
      ),
      onDismissed: (actionType) {
        setState(() {
          _listData.remove(_cakeData);
          _firestoreDataUpdate(_cakeData, isUndo: false);
        });

        Scaffold.of(context)
            .showSnackBar(_deleteSnackBar(_cakeData, index: index));
      },
    );
    // return super.setSlidableDrawerActionPane();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
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
  listViewThirdRow(int index) {
    bool isPickUpDateNull = _listData[index].pickUpDate == null;
    var _orderDateData = _listData[index].orderDate.toString().split('');
    var _pickUpDateData = _listData[index].pickUpDate.toString().split('');

    int _dateLength = _listData[index].orderDate.toString().split('').length;

    _orderDateData.removeRange(_dateLength - 7, _dateLength);
    _pickUpDateData.removeRange(_dateLength - 7, _dateLength);

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        margin: EdgeInsets.only(top: 3),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.event,
                      size: 20,
                    ),
                    Text(
                      !isPickUpDateNull ? _pickUpDateData.join() : "EMPTY",
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 13),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 12,
                    ),
                    Icon(
                      Icons.person,
                      size: 15,
                    ),
                    Expanded(
                      child: Text(
                        _listData[index].customerName +
                            "  " +
                            _listData[index].customerPhone,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: Colors.black, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }

  @override
  listViewSecondRow(int index) {
    return Container(
        margin: EdgeInsets.only(top: 2),
        child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 20,
          ),
          Icon(
            _listData[index].pickUpStatus ? Icons.check : Icons.close,
            color: Colors.redAccent,
            size: 18,
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Icon(
              Icons.payment,
              size: 20,
            ),
          ),
          Icon(
            _listData[index].payStatus ? Icons.check : Icons.close,
            color: Colors.redAccent,
            size: 18,
          )
        ]));
  }

  @override
  List<Widget> customSwipeIconWidget(int index) {
    var _cakeData = _listData[index];
    if (!_listData[index].pickUpStatus) {
      return [
        IconSlideAction(
          caption: 'Pick Up!',
          color: Colors.blueAccent,
          icon: Icons.shopping_bag_outlined,
          closeOnTap: true,
          onTap: () {
            setState(() {
              _firestoreDataUpdate(_cakeData, isUndo: false);
              // _listData.remove(_cakeData);
              // _listData.add(_cakeData);
            });
            Scaffold.of(context).showSnackBar(_pickUpSnackBar(_cakeData));
          },
        )
      ];
    }
    return [];
  }

  _pickUpSnackBar(var _cakeData) {
    return SnackBar(
      content: Text('픽업 완료!'),
      action: SnackBarAction(
        label: '취소',
        textColor: Colors.redAccent,
        onPressed: () {
          setState(() {
            // _listData.add(_cakeData);
            _firestoreDataUpdate(_cakeData, isUndo: true);
          });
        },
      ),
    );
  }

  @override
  setSlidableDrawerActionPane(int index) {
    return;
    // var _cakeData = _listData[index];

    // return SlidableDismissal(
    //   child: SlidableDrawerDismissal(
    //     key: UniqueKey(),
    //   ),
    //   onDismissed: (actionType) {
    //     setState(() {
    //       _listData.remove(_cakeData);
    //       _firestoreDataUpdate(_cakeData, isUndo: false);
    //     });

    //     Scaffold.of(context).showSnackBar(_pickUpSnackBar(_cakeData));
    //   },
    // );
    // return super.setSlidableDrawerActionPane();
  }

  Future _firestoreDataUpdate(CakeData cakeData,
      {@required bool isUndo}) async {
    FirebaseFirestore.instance
        .collection("Cake")
        .doc(cakeData.documentId)
        .update({"pickUpStatus": !isUndo ? true : false});
  }

  @override
  setListContainerBoxDecoration(int index) {
    if (_listData[index].pickUpStatus) {
      return BoxDecoration(
          color: Colors.lightBlue[200],
          borderRadius: BorderRadius.all(Radius.circular(5.0)));
    } else {
      return super.setListContainerBoxDecoration(index);
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

abstract class _TodayParent<T extends StatefulWidget> extends State<T>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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

  setSlidableDrawerActionPane(int index);
  setListContainerBoxDecoration(int index) {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(width: 1.0));
  }

  setListData();
  @override
  Widget build(BuildContext context) {
    _listData = setListData();

    return _listData != null
        ? _listData.length != 0
            ? Scaffold(
                key: _scaffoldKey,
                body: Container(
                  margin: EdgeInsets.only(top: 5),
                  child: ListView.builder(
                    itemCount: _listData.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        key: ValueKey(_listData[index].documentId),
                        actionPane: SlidableDrawerActionPane(),
                        secondaryActions: customSwipeIconWidget(index),
                        dismissal: setSlidableDrawerActionPane(index),
                        child: GestureDetector(
                          onTap: () {
                            // Navigator.pushNamed(context, '/DetailPage',
                            //     arguments: {"DATA": _listData[index]});
                            Navigator.pushNamed(context, '/DetailPage',
                                arguments: {"DATA": _listData[index]});
                          },
                          child: Container(
                              margin: EdgeInsets.all(5),
                              padding:
                                  EdgeInsets.only(left: 5, right: 5, top: 3),
                              decoration: setListContainerBoxDecoration(index),
                              height: MediaQuery.of(context).size.height / 6.2,
                              child: Column(
                                children: [
                                  listViewFirstRow(index),
                                  listViewSecondRow(index),
                                  listViewThirdRow(index),
                                  listViewFourthdRow(index)
                                ],
                              )),
                        ),
                      );
                    },
                  ),
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

  Widget listViewFourthdRow(int index) {
    String remark;
    if (_listData[index].remark == "")
      remark = "작성된 메모가 없습니다.";
    else
      remark = _listData[index].remark;
    return Container(
      margin: EdgeInsets.only(top: 3),
      child: Row(
        children: [
          Container(
              child: Icon(
            Icons.comment,
            size: 20,
          )),
          Expanded(
            child: Text(
              remark,
              style: TextStyle(fontSize: 14),
              maxLines: 1,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> customSwipeIconWidget(int index) {
    return [
      // IconSlideAction(
      //   caption: 'Update',
      //   color: Colors.grey,
      //   icon: Icons.edit,
      //   closeOnTap: false,
      //   onTap: () {
      //     // Navigator.pushNamed(context, '/AddOrder',arguments: );
      //   },
      // ),
      IconSlideAction(
        caption: 'PickUp!',
        color: Colors.redAccent,
        icon: Icons.close,
        closeOnTap: false,
        onTap: () {},
      )
    ];
  }

  listViewFirstRow(int index) {
    bool isCakePriceNull = _listData[index].cakePrice == null;
    bool isCakeCountNull = _listData[index].cakeCount == null;
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
        child: Row(children: [
      Icon(
        Icons.cake_outlined,
        size: 20,
      ),
      Text(
        !isCakePriceNull
            ? _listData[index].cakeCategory +
                _listData[index].cakeSize +
                " X" +
                _listData[index].cakeCount.toString()
            : "EMPTY",
        style: TextStyle(
            color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
      ),
      Spacer(),
      Icon(Icons.money),
      Text(!isCakeCountNull ? _addColon.join() : "EMPTY")
    ]));
  }

  listViewSecondRow(int index) {
    return Container(
        margin: EdgeInsets.only(top: 3),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
    bool isOrderDateNull = _listData[index].orderDate == null;
    bool isPickUpDateNull = _listData[index].pickUpDate == null;
    var _orderDateData = _listData[index].orderDate.toString().split('');
    var _pickUpDateData = _listData[index].pickUpDate.toString().split('');

    int _dateLength = _listData[index].orderDate.toString().split('').length;

    _orderDateData.removeRange(_dateLength - 7, _dateLength);
    _pickUpDateData.removeRange(_dateLength - 7, _dateLength);

    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        margin: EdgeInsets.only(top: 3),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.event,
                size: 20,
              ),
              Text(
                !isPickUpDateNull ? _pickUpDateData.join() : "EMPTY",
                style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 4,
          ),
          Row(
            children: [
              Icon(
                Icons.person,
                size: 15,
              ),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  !isOrderDateNull
                      ? _listData[index].partTimer +
                          "  " +
                          _orderDateData.join()
                      : "EMPTY",
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
