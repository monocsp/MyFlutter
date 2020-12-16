import 'package:flutter/material.dart';

class CakeCountWidget {
  int cakeCount;
  Function callback;
  CakeCountWidget({this.cakeCount, this.callback});
  Widget countWidget({bool isvisible}) {
    return Visibility(
      visible: isvisible ?? false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Text(
              '수량',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            // margin: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [_minusButton(), _countTextField(), _plusButton()],
            ),
          ),
        ],
      ),
    );
  }

  _minusButton() {
    return Visibility(
        visible: cakeCount > 1,
        child: Container(
            child: IconButton(
          icon: Icon(Icons.horizontal_rule),
          onPressed: () {
            callback(--cakeCount);
          },
        )));
  }

  _countTextField() {
    return Container(
        child: Text(
      cakeCount.toString(),
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
    ));
  }

  _plusButton() {
    return Container(
        child: IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        callback(++cakeCount);
      },
    ));
  }
}
