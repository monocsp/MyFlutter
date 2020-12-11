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
}

class _AddOrderState extends State<AddOrder> {
  static final double _text_MARGIN = 10;
  static final double _text_Font_Size = 15;
  // static final double _text_TOP_MARGIN = 5;
  CustomDate customDate;
  CustomDropDown customDropDown;

  CakeCategory _selectedCakeName;
  String _partTimer;
  CakeSizePrice _selectedCakeSize;
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
    _selectedCakeName = null;
    _partTimer = null;
    _selectedCakeSize = null;
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

  @override
  Widget build(BuildContext context) {
    customDate = CustomDate(context: context, setStateCallback: dateCallback);
    customDropDown =
        CustomDropDown(context: context, setStateCallback: dropDownCallback);
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 1,
                    child: customDropDown.selectCakeCategory(_selectedCakeName),
                  ),
                  Flexible(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.only(left: 30),
                        child: customDropDown.selectCakePrice(
                            currentCakeCategory: _selectedCakeName,
                            cakePrice: _selectedCakeSize),
                      ))
                ],
              ),
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

  dropDownCallback(var parameter,
      {CakeCategory cakeCategory, CakeSizePrice cakePrice}) {
    Map<String, String> arguments = Uri.parse(parameter).queryParameters;
    setState(() {
      if (arguments["parm1"] == "partTimer") {
        _partTimer = arguments["parm2"];
      } else if (arguments["parm1"] == "cakeCategory") {
        _selectedCakeName = cakeCategory;
      } else if (arguments["parm1"] == "cakePrice") {
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

  _customTextBox({@required bool isOrder}) {
    return Container(
        padding: EdgeInsets.only(left: _text_MARGIN, top: _text_MARGIN),
        child: _customTitle(
            title: isOrder ? '주문 날짜' : '픽업 날짜',
            important: isOrder ? false : true));
  }
}
