import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cakeorder/ProviderPackage/cakeList.dart';

class CustomDropDown {
  final BuildContext context;
  static final double _text_Font_Size = 15;
  Function
      setStateCallback; //Callback Parameter Format : "?parm1='STRING'&parm2='DATA'"
  List<CakeSizePrice> cakeSizeList = <CakeSizePrice>[];
  List<dynamic> partTimerProvider;
  List<CakeCategory> cakeCategoryProvider;
  CustomDropDown({this.context, this.setStateCallback}) {
    partTimerProvider = Provider.of<List<dynamic>>(context);
    cakeCategoryProvider = Provider.of<List<CakeCategory>>(context);
  }

  _customTitle({@required String title, bool important, double fontSize}) {
    return Text(
      title ?? "Empty",
      style: TextStyle(
          fontSize: fontSize ?? _text_Font_Size,
          fontWeight: FontWeight.bold,
          color: important ? Colors.redAccent : Colors.black),
    );
  }

  selectPartTimerDropDown(String partTimer) {
    List<DropdownMenuItem> _partTimerList = [];
    if (partTimerProvider != null) {
      partTimerProvider.forEach((element) {
        _partTimerList.add(new DropdownMenuItem(
          child: Text("$element"),
          value: element,
        ));
      });
    } else {
      Container(
        child: CupertinoActivityIndicator(),
      );
    }

    return Container(
      margin: EdgeInsets.only(left: 10, top: 15),
      child: Column(
        children: [
          _customTitle(title: "주문 받은사람", important: true),
          DropdownButton(
              value: partTimer,
              items: _partTimerList,
              onChanged: (value) =>
                  setStateCallback("?parm1=partTimer&parm2=$value")),
          // setStateCallback(value)),
        ],
      ),
    );
  }

  selectCakeCategory(CakeCategory cakeCategory) {
    List<DropdownMenuItem<CakeCategory>> _cakeCategories = [];

    if (cakeCategoryProvider == null) {
      Container(
        child: CupertinoActivityIndicator(),
      );
    } else {
      cakeCategoryProvider.forEach((element) {
        _cakeCategories.add(new DropdownMenuItem<CakeCategory>(
          child: Text("${element.name}"),
          value: element,
        ));
      });
    }
    return Container(
        margin: EdgeInsets.only(left: 10, top: 15),
        child: Column(children: [
          _customTitle(title: "주문 케이크 종류", important: true),
          DropdownButton(
              value: cakeCategory,
              items: _cakeCategories,
              onChanged: (value) {
                print('$value');
                setStateCallback("?parm1=cakeCategory", cakeCategory: value);
              }),
        ]));
  }

  selectCakePrice(
      {@required CakeCategory currentCakeCategory,
      List<CakeSizePrice> cakeList,
      CakeSizePrice selectedCakeSize}) {
    return currentCakeCategory != null
        ? Container(
            margin: EdgeInsets.only(left: 10, top: 20),
            child: Column(children: [
              _customTitle(title: "케이크 호수", important: true),
              cakeSizeList != null
                  ? DropdownButton<CakeSizePrice>(
                      hint: Text("선택하세요"),
                      value: selectedCakeSize,
                      onChanged: (CakeSizePrice value) => setStateCallback(
                          "?parm1=cakePrice",
                          cakePrice: value),
                      items: cakeList.map((CakeSizePrice cake) {
                        return DropdownMenuItem<CakeSizePrice>(
                          value: cake,
                          child: Text("${cake.cakeSize} : ${cake.cakePrice}"),
                        );
                      }).toList(),
                    )
                  : Container(
                      child: CupertinoActivityIndicator(),
                    ),
            ]),
          )
        : Container(
            margin: EdgeInsets.only(top: 20),
            child: _customTitle(
                title: '케이크를 선택해주세요', important: true, fontSize: 13));
  }
}
