import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cakeorder/addOrderPackage/addOrder.dart';
import 'package:cakeorder/ProviderPackage/cakeDataClass.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:provider/provider.dart';

class OrderAlterPage extends StatefulWidget {
  final CakeData cakeData;
  OrderAlterPage({Key key, this.cakeData}) : super(key: key);
  @override
  _AlterPageState createState() => _AlterPageState();
  // State createState() => new MyAppState();
}

class _AlterPageState extends AddOrderParent<OrderAlterPage> {
  List<CakeData> _forCrossValidationCakeList = [];
  CakeData _cakeData;
  @override
  navigatorPopAlertDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('수정 중'),
          content: Text("변경된 내용은 저장이 되지 않습니다."),
          actions: <Widget>[
            FlatButton(
                child: Text('나가기'),
                onPressed: () {
                  Navigator.of(context)
                      .popUntil(ModalRoute.withName("/DetailPage"));
                  // dispose();
                }),
            FlatButton(
              child: Text('유지'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      setInitiData(context);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  initData() async {
    return await CakeCategory().getCake(_cakeData.cakeCategory);
  }

  setInitiData(BuildContext context) {
    _cakeData = widget.cakeData;
    // Future.delayed(Duration(milliseconds: 1000));
    _forCrossValidationCakeList =
        Provider.of<List<CakeData>>(context, listen: false);
    _setCakeData();
    initData().then((cake) {
      setState(() {
        selectedCakeName = CakeCategory(
            name: cake.id,
            cakeSize: cake["CakePrice"].keys.toList(),
            cakePrice: cake["CakePrice"].values.toList());
        selectedCakeSize =
            CakeSizePrice(_cakeData.cakeSize, _cakeData.cakePrice);
        cakeCount = _cakeData.cakeCount;
        payStatus = _cakeData.payStatus;
        pickUpStatus = _cakeData.pickUpStatus;
        orderName = _cakeData.customerName;
        orderPhone = _cakeData.customerPhone;
        partTimer = _cakeData.partTimer;
        remarkText = _cakeData.remark ?? '';
        textEditingControllerRemark = TextEditingController()
          ..text = remarkText ?? '';
        textEditingControllerCustomerName = TextEditingController()
          ..text = orderName ?? '';
        textEditingControllerCustomerPhone = TextEditingController()
          ..text = orderPhone ?? '';
        textEditingControllerPickUpDate = TextEditingController()
          ..text = _cakeData.pickUpDate.toString().split(' ')[0];
        textEditingControllerPickUpTime = TextEditingController()
          ..text = DateFormat('kk:mm').format(_cakeData.pickUpDate);
        textEditingControllerOrderDate = TextEditingController()
          ..text = _cakeData.orderDate.toString().split(' ')[0];
        textEditingControllerOrderTime = TextEditingController()
          ..text = DateFormat('kk:mm').format(_cakeData.orderDate);
        currentDocumentId = _cakeData.documentId;
      });
      cake["CakePrice"].keys.toList().asMap().forEach((index, size) {
        int cakePrice;
        if (cake["CakePrice"].values.toList()[index].runtimeType == String)
          cakePrice = int.parse(cake["CakePrice"].values.toList()[index]);
        else
          cakePrice = cake["CakePrice"].values.toList()[index];
        cakeSizeList.add(new CakeSizePrice(size, cakePrice));
      });
    });
  }

  _setCakeData() {
    if (_forCrossValidationCakeList != null) if (_forCrossValidationCakeList
        .isNotEmpty) {
      for (final element in _forCrossValidationCakeList) {
        if (element.documentId == widget.cakeData.documentId) {
          _cakeData = element;
          break;
        }
      }
    }
  }

  @override
  Widget setAppbarMethod() {
    return AppBar(
      title: Text("수정하기"),
    );
  }

  @override
  setInitData() {
    isDetailPage = false;
  }

  @override
  Widget build(BuildContext context) {
    // test();
    return super.build(context);
    // }
  }

  @override
  thirdLineBuild() {
    return super.thirdLineBuild();

    // TODO: implement thirdLineBuild
  }

  @override
  addData() async {
    // setState(() {});
    await FirebaseFirestore.instance
        .collection("Cake")
        .doc(currentDocumentId)
        .delete();
    CakeData data = CakeData(
        orderDate: textEditingControllerOrderDate.text +
            " " +
            textEditingControllerOrderTime.text,
        pickUpDate: textEditingControllerPickUpDate.text +
            " " +
            textEditingControllerPickUpTime.text,
        cakeCategory: selectedCakeName.name,
        cakeSize: selectedCakeSize.cakeSize,
        cakePrice: selectedCakeSize.cakePrice,
        customerName: textEditingControllerCustomerName.text,
        customerPhone: textEditingControllerCustomerPhone.text,
        partTimer: partTimer,
        remark: textEditingControllerRemark.text,
        payStatus: payStatus,
        pickUpStatus: pickUpStatus,
        cakeCount: cakeCount,
        documentId: currentDocumentId);
    await data.updateFireStore(loadDialogCallback);
  }

  loadDialogCallback({bool isCompleted}) async {
    if (isCompleted == null) {
      Navigator.of(context).pop();
      TipDialogHelper.success("수정 완료!");
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
    } else {
      Navigator.of(context).pop();
    }
  }

  // @override
  // fifthLineBuild() {
  //   return Row(children: [
  //     customDropDown.selectPartTimerDropDown(partTimer),
  //     payAndPickUpStatusCheckBox(
  //       isPayStatus: true,
  //     ),
  //     payAndPickUpStatusCheckBox(isPayStatus: false)
  //   ]);
  // }
}

class DetailPage extends StatefulWidget {
  final CakeData cakeData;
  DetailPage({Key key, this.cakeData}) : super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends AddOrderParent<DetailPage> {
  List<CakeData> _forCrossValidationCakeList = [];
  CakeData _cakeData;
  @override
  bool get isDetailPage => true;
  @override
  settingOnWillPopMethod() {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    new Future.delayed(Duration.zero, () {
      setInitiData(context);
    });
  }

  _setCakeData() {
    if (_forCrossValidationCakeList != null) if (_forCrossValidationCakeList
        .isNotEmpty) {
      for (final element in _forCrossValidationCakeList) {
        if (element.documentId == widget.cakeData.documentId) {
          _cakeData = element;
          break;
        }
      }
    }
  }

  setInitiData(BuildContext context) {
    _cakeData = widget.cakeData;
    // Future.delayed(Duration(milliseconds: 1000));
    _forCrossValidationCakeList =
        Provider.of<List<CakeData>>(context, listen: false);

    _setCakeData();
    initData().then((cake) {
      setState(() {
        var dateTimePickUpDate = _cakeData.pickUpDate;
        var dateTimeOrderDate = _cakeData.orderDate;
        if (dateTimePickUpDate.runtimeType == Timestamp) {
          dateTimePickUpDate = dateTimePickUpDate.toDate();
        }
        if (dateTimeOrderDate.runtimeType == Timestamp) {
          dateTimePickUpDate = _cakeData.orderDate.toDate();
        }

        selectedCakeName = CakeCategory(
            name: cake.id,
            cakeSize: cake["CakePrice"].keys.toList(),
            cakePrice: cake["CakePrice"].values.toList());
        selectedCakeSize =
            CakeSizePrice(_cakeData.cakeSize, _cakeData.cakePrice);
        cakeCount = _cakeData.cakeCount;
        payStatus = _cakeData.payStatus;
        pickUpStatus = _cakeData.pickUpStatus;
        orderName = _cakeData.customerName;
        orderPhone = _cakeData.customerPhone;
        partTimer = _cakeData.partTimer;
        remarkText = _cakeData.remark ?? '';
        textEditingControllerRemark = TextEditingController()
          ..text = remarkText ?? '';
        textEditingControllerCustomerName = TextEditingController()
          ..text = orderName ?? '';
        textEditingControllerCustomerPhone = TextEditingController()
          ..text = orderPhone ?? '';
        textEditingControllerPickUpDate = TextEditingController()
          ..text = _cakeData.pickUpDate.toString().split(' ')[0];
        textEditingControllerPickUpTime = TextEditingController()
          ..text = DateFormat('kk:mm').format(dateTimePickUpDate);
        textEditingControllerOrderDate = TextEditingController()
          ..text = _cakeData.orderDate.toString().split(' ')[0];
        textEditingControllerOrderTime = TextEditingController()
          ..text = DateFormat('kk:mm').format(dateTimeOrderDate);
        currentDocumentId = _cakeData.documentId;
        cake["CakePrice"].keys.toList().asMap().forEach((index, size) {
          int cakePrice;
          if (cake["CakePrice"].values.toList()[index].runtimeType == String)
            cakePrice = int.parse(cake["CakePrice"].values.toList()[index]);
          else
            cakePrice = cake["CakePrice"].values.toList()[index];
          cakeSizeList.add(new CakeSizePrice(size, cakePrice));
        });
      });
    });
  }

  @override
  setInitData() {
    isDetailPage = true;
  }

  initData() async {
    return await CakeCategory().getCake(_cakeData.cakeCategory);
  }

  @override
  Widget setAppbarMethod() {
    return AppBar(
      title: Text("상세보기"),
      actions: [
        PopupMenuButton(
            onSelected: (route) {
              switch (route) {
                case "OrderAlterPage":
                  Navigator.pushNamed(context, "/" + route,
                      arguments: {"DATA": _cakeData});
                  break;
                case "Delete":
                  deleteAlertDialog();
                  break;
              }
            },
            itemBuilder: (BuildContext bc) => [
                  PopupMenuItem(child: Text("수정하기"), value: "OrderAlterPage"),
                  PopupMenuItem(
                      child: Text(
                        "삭제",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      value: "Delete"),
                ])
      ],
    );
  }

  deleteAlertDialog() {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제'),
          content: Text("삭제된 내용은 복구되지 않습니다."),
          actions: <Widget>[
            FlatButton(
              child: Text(
                '삭제',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            FlatButton(
              child: Text('유지'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
          ],
        );
      },
    ).then((value) async {
      if (value != null && value) {
        await FirebaseFirestore.instance
            .collection("Cake")
            .doc(_cakeData.documentId)
            .delete()
            .catchError((onError) {
              TipDialogHelper.fail("삭제 실패! \n $onError");
            })
            .then((value) {})
            .whenComplete(() {});
        Navigator.pop(context, _cakeData);
      }
    });
    // .whenComplete(() {
    //   Navigator.popUntil(
    //       context,
    //       ModalRoute.withName(
    //         "/",
    //       ));
    // });
  }

  Future updateStatus(String statusCase) async {
    switch (statusCase) {
      case "payStatus":
        await FirebaseFirestore.instance
            .collection("Cake")
            .doc(_cakeData.documentId)
            .update({
          "payStatus": _cakeData.payStatus ? false : true
        }).whenComplete(() {
          scaffoldKey.currentState.showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                "결제가 업데이트 되었습니다!",
              ),
              duration: Duration(seconds: 1)));
        });
        break;
      case "pickUpStatus":
        await FirebaseFirestore.instance
            .collection("Cake")
            .doc(_cakeData.documentId)
            .update({"pickUpStatus": !_cakeData.pickUpStatus}).then((value) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                "픽업이 업데이트 되었습니다!",
              ),
              duration: Duration(seconds: 1)));
        });
        break;
    }
  }

  @override
  fifthLineBuild() {
    return Row(children: [
      customDropDown.selectPartTimerDropDown(partTimer),
      payAndPickUpStatusCheckBox(
          isPayStatus: true, payStatusUpdateFireStore: updateStatus),
      payAndPickUpStatusCheckBox(
          isPayStatus: false, payStatusUpdateFireStore: updateStatus)
    ]);
  }
}
