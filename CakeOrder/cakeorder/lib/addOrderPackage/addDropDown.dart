import 'package:flutter/material.dart';
import 'addOrder.dart';
import 'orderStore.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:cakeorder/ProviderPackage/cakeList.dart';

class CustomDropDown {
  final BuildContext context;
  static final double _text_Font_Size = 15;
  Function
      setStateCallback; //Callback Parameter Format : "?parm1='STRING'&parm2='DATA'"

  List<dynamic> partTimerProvider;
  List<CakeCategory> cakeCategoryProvider;
  List<CakeSizePrice> cakeSizeList = [];
  CustomDropDown({this.context, this.setStateCallback}) {
    partTimerProvider = Provider.of<List<dynamic>>(context);
    cakeCategoryProvider = Provider.of<List<CakeCategory>>(context);
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
                setStateCallback("?parm1=cakeCategory", cakeCategory: value);
              }),
        ]));
  }

  selectCakePrice(
      {@required CakeCategory currentCakeCategory, CakeSizePrice cakePrice}) {
    currentCakeCategory != null ? _dropDownItems(currentCakeCategory) : null;
    print(cakeSizeList);
    return currentCakeCategory != null
        ? Container(
            margin: EdgeInsets.only(left: 10, top: 15),
            child: Column(children: [
              _customTitle(title: "케이크 호수", important: true),
              DropdownButton<CakeSizePrice>(
                value: cakePrice,
                onChanged: (CakeSizePrice value) {
                  setStateCallback("?parm1=cakePrice", cakePrice: value);
                  // print(cakeSizeList.contains(value));
                },
                items: cakeSizeList.map((CakeSizePrice cake) {
                  return new DropdownMenuItem<CakeSizePrice>(
                    value: cake,
                    child: Text(cake.cakeSize),
                  );
                }).toList(),
              ),
            ]))
        : Container(child: _customTitle(title: '케이크를 선택해주세요', important: true));
  }

  _dropDownItems(CakeCategory cakeCategory) {
    for (int i = 0; i < cakeCategory.cakePrice.length; i++) {
      cakeSizeList.add(new CakeSizePrice(
          cakeSize: cakeCategory.cakeSize[i],
          cakePrice: cakeCategory.cakePrice[0]));
    }
    // List<DropdownMenuItem<CakeSizePrice>> _cakePriceItems = [];
    // for (int i = 0; i < cakeCategory.cakeSize.length; i++) {

    //   _cakePriceItems.add(new DropdownMenuItem<CakeSizePrice>(
    //     child: Text("${cakeCategory.cakeSize[i]}"),
    //     value: new CakeSizePrice(
    //         cakeSize: cakeCategory.cakeSize[i].toString(),
    //         cakePrice: cakeCategory.cakePrice[i].toString()),
    //   ));
    // }
    // return _cakePriceItems;
  }
}

class CakeSizePrice {
  final String cakeSize;
  final String cakePrice;
  CakeSizePrice({this.cakeSize, this.cakePrice});
}
