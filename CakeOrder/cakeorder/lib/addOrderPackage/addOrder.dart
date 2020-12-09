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
}

class _AddOrderState extends State<AddOrder> {
  static final double _text_MARGIN = 10;
  static final double _text_Font_Size = 15;
  // static final double _text_TOP_MARGIN = 5;
  CustomDate customDate;
  CustomDropDown customDropDown;

  String _selectedCakeName;
  String _selectedCakeSize;
  String _partTimer;
  Map<dynamic, dynamic> _cakePriceList;
  TextEditingController _textEditingControllerOrderDate;
  TextEditingController _textEditingControllerPickUpDate;
  TextEditingController _textEditingControllerOrderTime;
  TextEditingController _textEditingControllerPickUpTime;
  var _todayDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
          .split(' ')[0];
  String _todayTime =
      DateFormat('kk:mm:a').format(DateTime.now().add(Duration(hours: 9)));

  @override
  void initState() {
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
    } else {
      _textEditingControllerOrderDate.dispose();
      _textEditingControllerOrderTime.dispose();
      _textEditingControllerPickUpDate.dispose();
      _textEditingControllerPickUpTime.dispose();
    }
  }

  @override
  void dispose() {
    initNdisposeTextEditController(init: false);
    // TODO: implement dispose
    super.dispose();
  }

  dropDownCallback(var value) {
    setState(() {
      _partTimer = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    customDate = CustomDate(context: context, setStateCallback: dateCallback);
    customDropDown =
        CustomDropDown(context: context, setStateCallback: dropDownCallback);
    return Scaffold(
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
              _selectCakeNsizeDropDown(),
              _orderNamePhoneTextField(),
              customDropDown.selectPartTimerDropDown(_partTimer),
            ],
          ),
        ),
      ),
    );
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

  _selectCakeNsizeDropDown() {
    return Container(
        child: Column(children: <Widget>[
      Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.only(top: _text_MARGIN, left: _text_MARGIN),
        child: _customTitle(title: '주문 케이크 종류 및 호수', important: true),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: _dropDownCakeList(isCakeList: true)),
          Flexible(child: _dropDownCakeList(isCakeList: false)),
        ],
      ),
    ]));
  }

  _dropDownCakeList({@required bool isCakeList}) {
    bool _isCakeSelected;
    if (_selectedCakeName == null)
      _isCakeSelected = false;
    else
      _isCakeSelected = true;
    return Container(
        margin: EdgeInsets.only(left: 30),
        child: isCakeList
            //CakeList DropDown
            ? StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("CakeList")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(child: Text('Loding'));
                  } else {
                    List<DropdownMenuItem> cakeitems = [];
                    for (int i = 0; i < snapshot.data.docs.length; i++) {
                      DocumentSnapshot docSnapshot = snapshot.data.docs[i];
                      cakeitems.add(DropdownMenuItem(
                        child: Text(docSnapshot.id.toString()),
                        value: "${docSnapshot.id}",
                      ));
                    }
                    return Row(children: <Widget>[
                      DropdownButton(
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                          items: cakeitems,
                          value: _selectedCakeName,
                          onChanged: (value) {
                            setState(() {
                              _selectedCakeName = value;
                            });
                          }),
                    ]);
                  }
                },
              )
            //CakeSize DropDown
            : _isCakeSelected
                ? _testCakeSizeString()
                : Container(
                    margin: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '케이크 선택',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.redAccent),
                    )));
  }

  _testCakeSizeString() {
    var _section;
    List<DropdownMenuItem> _cakeSizeList = [];
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection("CakeList")
          .doc(_selectedCakeName)
          .snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          Center(child: CupertinoActivityIndicator());
        } else {
          _cakePriceList = null;
          _section = snapshot.data.data();

          _cakePriceList = _section;
          for (int i = 0; i < _section.length; i++) {
            var _dropDownMenuItem = DropdownMenuItem(
              child: Text(
                  "${_section.keys.toList()[i]} : ${_section.values.toList()[i]}"),
              value: _section.keys.toList()[i],
            );

            _cakeSizeList.add(_dropDownMenuItem);
          }
        }
        // print(_selectedCakeSize);

        return DropdownButton(
          value: _selectedCakeSize,
          items: _cakeSizeList,
          onChanged: (value) {
            setState(() {
              _selectedCakeSize = value;
              print(_cakePriceList);

              // print(_selectedCakeSize.runtimeType);
            });
          },
        );
        // print(snapshot);
      },
    );
  }

  _customTextBox({@required bool isOrder}) {
    return Container(
        padding: EdgeInsets.only(left: _text_MARGIN, top: _text_MARGIN),
        child: _customTitle(
            title: isOrder ? '주문 날짜' : '픽업 날짜',
            important: isOrder ? false : true));
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
                String _selectTime = DateFormat('kk:mm:a').format(time);
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

  onChangeDropDown(String selectName) {
    setState(() {
      _selectedCakeName = selectName;
    });
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
                    decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: '성함',
            ))),
            Flexible(
              child: TextField(
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

  _customTitle({@required String title, bool important}) {
    return Text(
      title ?? "Empty",
      style: TextStyle(
          fontSize: _text_Font_Size,
          fontWeight: FontWeight.bold,
          color: important ? Colors.redAccent : Colors.black),
    );
  }
}
