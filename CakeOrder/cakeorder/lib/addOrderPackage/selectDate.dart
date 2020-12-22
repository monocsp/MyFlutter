import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class CustomDate {
  final BuildContext context;
  Function setStateCallback;
  CustomDate({this.context, this.setStateCallback});

  Widget dateNtimeRow(
      {@required bool isOrderRow,
      TextEditingController controllerCalendar,
      TextEditingController controllerTimer}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        //Pick Calendar
        Flexible(
          child: Container(
            padding: EdgeInsets.only(left: 5),
            child: GestureDetector(
              onTap: () => showDialog(
                context: context,
                barrierColor: Colors.white,
                builder: (context) => Container(
                  child: SfDateRangePicker(
                    todayHighlightColor: Colors.red,
                    enablePastDates: isOrderRow ? true : false,
                    onSelectionChanged: (arg) =>
                        _onSelectionChanged(arg, isOrderRow),
                  ),
                ),
              ),
              child: _customTextField(controllerCalendar,
                  isOrderDate: isOrderRow, isCalendar: true),
            ),
          ),
        ),
        // Setting time
        Flexible(
          child: Container(
            padding: EdgeInsets.only(right: 5),
            child: GestureDetector(
              onTap: () => showAlertDialog(context,
                  isOrderTime: isOrderRow, pickUpTime: controllerTimer),
              child: _customTextField(controllerTimer,
                  isOrderDate: isOrderRow, isCalendar: false),
            ),
          ),
        ),
        // SfDateRangePicker()
      ],
    );
  }

  void _onSelectionChanged(
      DateRangePickerSelectionChangedArgs arg, bool isOrder) {
    var _selectDate = arg.value.toString().split(' ')[0];
    if (isOrder)
      this.setStateCallback("?isOrder=true&isCalendar=true&data=$_selectDate");
    else
      this.setStateCallback("?isOrder=false&isCalendar=true&data=$_selectDate");
    Navigator.pop(context);
  }

  _customTextField(TextEditingController textEditingController,
      {@required bool isOrderDate, @required bool isCalendar}) {
    return TextField(
      enabled: false,
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: isOrderDate ?? '날짜' ? '주문 날짜' : '픽업 날짜',
        labelStyle:
            TextStyle(color: isOrderDate ? Colors.black : Colors.redAccent),
        icon: isCalendar ? Icon(Icons.calendar_today) : Icon(Icons.timer),
      ),
    );
  }

  void showAlertDialog(BuildContext context,
      {@required bool isOrderTime, var pickUpTime}) async {
    String result = await showDialog(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: isOrderTime ? Text('주문시간 설정') : Text('픽업시간 설정'),
          content: TimePickerSpinner(
            is24HourMode: true,
            time: setInitDateTime(isOrderTime, pickUpTime),
            minutesInterval: isOrderTime ? 1 : 5,
            spacing: 50,
            itemHeight: 80,
            isForce2Digits: true,
            onTimeChange: (time) {
              String _selectTime = DateFormat('kk:mm').format(time);
              if (isOrderTime)
                this.setStateCallback(
                    "?isOrder=true&isCalendar=false&data=$_selectTime");
              else
                this.setStateCallback(
                    "?isOrder=false&isCalendar=false&data=$_selectTime");
            },
          ),
        );
      },
    );
  }

  setInitDateTime(bool isOrder, var pickUpTime) {
    return pickUpTime.text == ''
        ? isOrder
            ? DateTime.now().add(Duration(hours: 9)) //set Current Time
            : DateTime.parse(DateTime.now().toString().split(' ')[0] +
                " 00:00:00.000") //set 00
        : DateTime.parse(DateTime.now().toString().split(' ')[0] +
            " " +
            pickUpTime.text +
            ":00.000"); //set previous time
  }
}
