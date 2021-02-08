import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:cakeorder/ProviderPackage/cakeDataClass.dart';

class CustomDropDown {
  final BuildContext context;
  bool isClickable = true;
  static final double _text_Font_Size = 15;
  Function
      setStateCallback; //Callback Parameter Format : "?parm1='STRING'&parm2='DATA'"
  List<CakeSizePrice> cakeSizeList = <CakeSizePrice>[];
  List<dynamic> partTimerProvider;
  List<CakeCategory> cakeCategoryProvider;
  CustomDropDown({this.context, this.setStateCallback, this.isClickable}) {
    getData(context);
  }
  Future getData(BuildContext context) async {
    partTimerProvider = Provider.of<List<dynamic>>(
      context,
    );
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
          child: Center(child: Text("$element")),
          value: element,
        ));
      });
    } else {
      Container(
        child: CupertinoActivityIndicator(),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width / 3,
      margin: EdgeInsets.only(left: 10, top: 15),
      child: Column(
        children: [
          _customTitle(title: "주문 받은사람", important: true),
          IgnorePointer(
            ignoring: !isClickable,
            child: DropdownButton(
                isExpanded: true,
                value: partTimer,
                items: _partTimerList,
                onChanged: (value) =>
                    setStateCallback("?parm1=partTimer&parm2=$value")),
          )

          // setStateCallback(value)),
        ],
      ),
    );
  }

  selectCakeCategory(CakeCategory cakeCategory) {
    List<DropdownMenuItem<String>> _cakeCategories = [];
    if (cakeCategoryProvider == null) {
      Container(
        child: CupertinoActivityIndicator(),
      );
    } else {
      cakeCategoryProvider.forEach((element) {
        _cakeCategories.add(new DropdownMenuItem<String>(
          child: Center(child: Text("${element.name}")),
          value: element.name,
        ));
      });
    }
    return Container(
        margin: EdgeInsets.only(left: 10, top: 15),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _customTitle(
              title: isClickable ? "주문 케이크 종류" : "주문 케이크", important: true),
          IgnorePointer(
            ignoring: !isClickable,
            child: DropdownButton(
                isExpanded: true,
                value: cakeCategory != null ? cakeCategory.name : cakeCategory,
                items: _cakeCategories,
                onChanged: (value) {
                  CakeCategory cake;
                  for (final element in cakeCategoryProvider) {
                    if (element.name == value) {
                      cake = element;
                    }
                  }

                  setStateCallback("?parm1=cakeCategory", cakeCategory: cake);
                }),
          ),
          // Row(
          //     children: [
          //       Container(
          //         margin: EdgeInsets.only(left: 15),
          //         child: Icon(
          //           Icons.cake,
          //           color: Colors.grey,
          //         ),
          //       ),
          //       Expanded(
          //         child: Text(displayText ?? ''),
          //       ),
          // ],
          // ),
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
                  ? IgnorePointer(
                      ignoring: !isClickable,
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text("선택하세요"),
                        value: selectedCakeSize != null
                            ? selectedCakeSize.cakeSize
                            : selectedCakeSize,
                        onChanged: (String value) {
                          var result;
                          for (final _cake in cakeList) {
                            if (_cake.cakeSize == value) {
                              result = _cake;
                              break;
                            }
                          }
                          setStateCallback("?parm1=cakePrice",
                              cakePrice: result);
                        },
                        items: cakeList.map((CakeSizePrice cake) {
                          return DropdownMenuItem<String>(
                            value: cake.cakeSize,
                            child: Text("${cake.cakeSize} : ${cake.cakePrice}"),
                          );
                        }).toList(),
                      ),
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
