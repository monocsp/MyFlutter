import 'package:flutter/material.dart';
import 'addOrder.dart';
import 'orderStore.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class CustomDropDown {
  final BuildContext context;
  static final double _text_Font_Size = 15;
  Function setStateCallback;

  List<dynamic> partTimerProvider;
  CustomDropDown({this.context, this.setStateCallback}) {
    partTimerProvider = Provider.of<List<dynamic>>(context);
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

  Widget selectPartTimerDropDown(String partTimer) {
    List<DropdownMenuItem> _partTimerList = [];
    partTimerProvider.forEach((element) {
      _partTimerList.add(new DropdownMenuItem(
        child: Text("$element"),
        value: element,
      ));
    });
    return Container(
      margin: EdgeInsets.only(left: 10, top: 15),
      child: Column(
        children: [
          _customTitle(title: "주문 받은사람", important: true),
          DropdownButton(
              value: partTimer,
              items: _partTimerList,
              onChanged: (value) => setStateCallback(value)),
        ],
      ),
    );
  }
}
