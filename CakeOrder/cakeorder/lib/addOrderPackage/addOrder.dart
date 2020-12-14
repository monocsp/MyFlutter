import 'package:cakeorder/ProviderPackage/cakeList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import 'addDropDown.dart';
import 'addDate.dart';

class AddOrder extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
  // State createState() => new MyAppState();
}

class _AddOrderState extends State<AddOrder> {
  static final double _text_MARGIN = 10;
  static final double _text_Font_Size = 15;
  bool addProgressStatus;
  // static final double _text_TOP_MARGIN = 5;
  CustomDate customDate;
  CustomDropDown customDropDown;
  List<CakeSizePrice> cakeSizeList = <CakeSizePrice>[];
  CakeCategory _selectedCakeName;
  CakeCategory _beforeCakeName;
  String _partTimer;
  CakeSizePrice _selectedCakeSize;
  TextEditingController _textEditingControllerRemark;
  TextEditingController _textEditingControllerOrderDate;
  TextEditingController _textEditingControllerPickUpDate;
  TextEditingController _textEditingControllerOrderTime;
  TextEditingController _textEditingControllerPickUpTime;
  TextEditingController _textEditingControllerCustomerName;
  TextEditingController _textEditingControllerCustomerPhone;
  var _todayDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
          .split(' ')[0];
  String _todayTime =
      DateFormat('kk:mm').format(DateTime.now().add(Duration(hours: 9)));

  @override
  void initState() {
    addProgressStatus = null;
    _selectedCakeName = null;
    _partTimer = null;
    initNdisposeTextEditController(init: true);
    super.initState();
  }

  initNdisposeTextEditController({@required bool init}) {
    if (init) {
      _textEditingControllerOrderDate = TextEditingController()
        ..text = _todayDate;
      _textEditingControllerOrderTime = TextEditingController()
        ..text = _todayTime;
      _textEditingControllerPickUpDate = TextEditingController();
      _textEditingControllerPickUpTime = TextEditingController();
      _textEditingControllerRemark = TextEditingController();
      _textEditingControllerCustomerName = TextEditingController();
      _textEditingControllerCustomerPhone = TextEditingController();
    } else {
      _textEditingControllerOrderDate.dispose();
      _textEditingControllerOrderTime.dispose();
      _textEditingControllerPickUpDate.dispose();
      _textEditingControllerPickUpTime.dispose();
      _textEditingControllerCustomerName.dispose();
      _textEditingControllerCustomerPhone.dispose();
    }
  }

  @override
  void dispose() {
    initNdisposeTextEditController(init: false);
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    customDate = CustomDate(context: context, setStateCallback: dateCallback);
    customDropDown =
        CustomDropDown(context: context, setStateCallback: dropDownCallback);
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('예약하기'),
      ),
      body: GestureDetector(
        onTap: () {
          //If tap ouside, hide keyboard
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.transparent,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _customTextBox(isOrder: true),
                customDate.dateNtimeRow(
                    isOrderRow: true,
                    controllerCalendar: _textEditingControllerOrderDate,
                    controllerTimer: _textEditingControllerOrderTime),
                _customTextBox(isOrder: false),
                customDate.dateNtimeRow(
                    isOrderRow: false,
                    controllerCalendar: _textEditingControllerPickUpDate,
                    controllerTimer: _textEditingControllerPickUpTime),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 1,
                      child:
                          customDropDown.selectCakeCategory(_selectedCakeName),
                    ),
                    Flexible(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.only(left: 30),
                          child: customDropDown.selectCakePrice(
                              currentCakeCategory: _selectedCakeName,
                              cakeList: cakeSizeList,
                              selectedCakeSize: _selectedCakeSize),
                        ))
                  ],
                ),
                _orderNamePhoneTextField(),
                customDropDown.selectPartTimerDropDown(_partTimer),
                _remarkTextField(context),
                addButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  addButton() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: Center(
        child: RaisedButton(
            child: Text(
              "저장",
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
                side: BorderSide(color: Colors.blueAccent)),
            onPressed: () {
              dialogProgressIndicator(addProgressStatus);
              CakeData data = CakeData(
                  orderDate: _textEditingControllerOrderDate.text +
                      " " +
                      _textEditingControllerOrderTime.text,
                  pickUpDate: _textEditingControllerPickUpDate.text +
                      " " +
                      _textEditingControllerPickUpTime.text,
                  cakeCategory: _selectedCakeName.name,
                  cakeSize: _selectedCakeSize.cakeSize,
                  cakePrice: _selectedCakeSize.cakePrice,
                  customerName: _textEditingControllerCustomerName.text,
                  customerPhone: _textEditingControllerCustomerPhone.text);
              data.toFireStore(loadDialogCallback);
              print(data.documentId);
              print(data.pickUpDate.toDate());
              print(data.orderDate.toDate());
              // c.toFireStore(loadDialogCallback);
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
            }),
      ),
    );
  }

  dialogProgressIndicator(bool status) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              backgroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              content: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.black.withOpacity(0.8),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                            child: Container(
                                child: status == null
                                    ? CircularProgressIndicator(
                                        strokeWidth: 3,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : status
                                        ? Icon(
                                            Icons.check,
                                            size: 20,
                                          )
                                        : Icon(
                                            Icons.error_outline,
                                            size: 20,
                                          ),
                                width: 32,
                                height: 32),
                            padding: EdgeInsets.only(bottom: 16)),
                        Padding(
                            child: Text(
                              'Please wait …',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            padding: EdgeInsets.only(bottom: 4)),
                        Text(
                          "displayedText",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        )
                      ])),
            ));
      },
    );
  }

  loadDialogCallback() {
    Navigator.of(context).popUntil(ModalRoute.withName('/'));
    // Navigator.of(context).pushNamed(ModalRoute.withName('/AddOrder'));
    // Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  dateCallback(String param) {
    Map<String, dynamic> arguments = Uri.parse(param).queryParameters;
    //MapKey : isOrder, isCalendar, data

    setState(() {
      if (arguments["isOrder"] == "true") {
        if (arguments["isCalendar"] == "true") {
          _textEditingControllerOrderDate..text = arguments["data"];
        } else {
          _textEditingControllerOrderTime..text = arguments["data"];
        }
      } else {
        if (arguments["isCalendar"] == "true") {
          _textEditingControllerPickUpDate..text = arguments["data"];
        } else {
          _textEditingControllerPickUpTime..text = arguments["data"];
        }
      }
    });
  }

  _resetCakePriceList(CakeCategory cakeCategory) {
    cakeSizeList.clear();
    if (cakeCategory != null) {
      for (int i = 0; i < cakeCategory.cakePrice.length; i++) {
        cakeSizeList.add(
            CakeSizePrice(cakeCategory.cakeSize[i], cakeCategory.cakePrice[i]));
      }
    }
  }

  dropDownCallback(var parameter,
      {CakeCategory cakeCategory, CakeSizePrice cakePrice}) {
    Map<String, String> arguments = Uri.parse(parameter).queryParameters;
    setState(() {
      if (arguments["parm1"] == "partTimer") {
        _partTimer = arguments["parm2"];
      } else if (arguments["parm1"] == "cakeCategory") {
        if (_selectedCakeName != cakeCategory) {
          _selectedCakeSize = null;
          _resetCakePriceList(cakeCategory);
        }
        _selectedCakeName = cakeCategory;
      } else if (arguments["parm1"] == "cakePrice") {
        print(cakePrice);
        _selectedCakeSize = cakePrice;
      }
    });
  }

  void showAlertDialog(BuildContext context,
      {@required bool isOrderTime}) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: isOrderTime ? Text('주문시간 설정') : Text('픽업시간 설정'),
          content: TimePickerSpinner(
            is24HourMode: true,
            time: DateTime.now().add(Duration(hours: 9)),
            minutesInterval: isOrderTime ? 1 : 5,
            spacing: 50,
            itemHeight: 80,
            isForce2Digits: true,
            onTimeChange: (time) {
              setState(() {
                String _selectTime = DateFormat('kk:mm').format(time);
                isOrderTime
                    ? _textEditingControllerOrderTime.text = '$_selectTime'
                    : _textEditingControllerPickUpTime.text = '$_selectTime';
              });
            },
          ),
        );
      },
    );
  }

  _orderNamePhoneTextField() {
    return Container(
      margin: EdgeInsets.only(left: 10, top: 10, right: 5),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            alignment: Alignment.centerLeft,
            child: _customTitle(title: '주문자 정보', important: true),
          ),
          Row(children: <Widget>[
            Flexible(
                child: TextField(
                    controller: _textEditingControllerCustomerName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '성함',
                    ))),
            Flexible(
              child: TextField(
                  controller: _textEditingControllerCustomerPhone,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '전화번호',
                  )),
            )
          ]),
        ],
      ),
    );
  }

  _remarkTextField(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 10,
          left: 10),
      decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      child: TextField(
        decoration: InputDecoration(
          // counterText:
          //     '${this._textEditingControllerRemark.text.split(' ').length} words',
          labelText: '비고',
          hintText: '만나서 카드결제 등',
        ),
        controller: _textEditingControllerRemark,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
    );
  }

  _customTitle({@required String title, bool important}) {
    return Text(
      title ?? "Empty",
      style: TextStyle(
          fontSize: _text_Font_Size,
          fontWeight: FontWeight.bold,
          color: important ? Colors.redAccent : Colors.black),
    );
  }

  _customTextBox({@required bool isOrder}) {
    return Container(
        padding: EdgeInsets.only(left: _text_MARGIN, top: _text_MARGIN),
        child: _customTitle(
            title: isOrder ? '주문 날짜' : '픽업 날짜',
            important: isOrder ? false : true));
  }
}
