import 'package:cakeorder/ProviderPackage/cakeDataClass.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'addDropDown.dart';
import 'selectDate.dart';
import 'cakeCount.dart';
import 'package:tip_dialog/tip_dialog.dart';
import 'package:async/async.dart';

class AddOrder extends StatefulWidget {
  // final bool canAlter;
  const AddOrder({
    Key key,
  }) : super(key: key);
  @override
  _AddOrderState createState() => _AddOrderState();
  // State createState() => new MyAppState();
}

class _AddOrderState extends AddOrderParent<AddOrder> {
  @override
  setInitData() {
    isDetailPage = false;
  }
}

abstract class AddOrderParent<T extends StatefulWidget> extends State<T> {
  @override
  // TODO: implement widget
  // factory AddOrderParent.toDetailPage();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  double _text_MARGIN = 10;
  double _text_Font_Size = 15;
  bool payStatus;
  bool pickUpStatus;
  bool isDetailPage;
  bool payInStore;
  bool payInCash;
  CustomDate customDate;
  CustomDropDown customDropDown;
  CakeCountWidget cakeCountWidget;
  List<CakeSizePrice> cakeSizeList = <CakeSizePrice>[];
  CakeCategory selectedCakeName;
  String partTimer;
  int cakeCount;
  CakeSizePrice selectedCakeSize;
  TextEditingController textEditingControllerRemark;
  TextEditingController textEditingControllerOrderDate;
  TextEditingController textEditingControllerPickUpDate;
  TextEditingController textEditingControllerOrderTime;
  TextEditingController textEditingControllerPickUpTime;
  TextEditingController textEditingControllerCustomerName;
  TextEditingController textEditingControllerCustomerPhone;
  var _todayDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
          .toString()
          .split(' ')[0];
  String _todayTime = DateFormat('kk:mm').format(DateTime.now());
  setInitData();
  CakeData cakeData;
  customInitData() {
    cakeCount = 1;
    payStatus = null;
    pickUpStatus = null;
    selectedCakeName = null;
    partTimer = null;
    payInStore = null;
    payInCash = null;
  }

  String orderDate;
  String orderTime;
  String pickUpDate;
  String pickUpTime;
  String orderName;
  String orderPhone;
  String remarkText;
  String aboutCakeText;
  String currentDocumentId;
  @override
  void initState() {
    customInitData();
    setInitData();
    initNdisposeTextEditController(init: true);
    super.initState();
  }

  initNdisposeTextEditController({@required bool init}) {
    if (init) {
      textEditingControllerOrderDate = TextEditingController()
        ..text = _todayDate;
      textEditingControllerOrderTime = TextEditingController()
        ..text = _todayTime;
      textEditingControllerPickUpDate = TextEditingController();
      textEditingControllerPickUpTime = TextEditingController();
      textEditingControllerRemark = TextEditingController()
        ..text = remarkText ?? '';
      textEditingControllerCustomerName = TextEditingController()
        ..text = orderName ?? '';
      textEditingControllerCustomerPhone = TextEditingController()
        ..text = orderPhone ?? '';
    } else {
      textEditingControllerOrderDate.dispose();
      textEditingControllerOrderTime.dispose();
      textEditingControllerPickUpDate.dispose();
      textEditingControllerPickUpTime.dispose();
      textEditingControllerCustomerName.dispose();
      textEditingControllerCustomerPhone.dispose();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    initNdisposeTextEditController(init: false);
    super.dispose();
  }

  Widget setAppbarMethod() {
    return AppBar(title: Text("예약하기"));
  }

  settingOnWillPopMethod() =>
      !_catchWrite() ? Navigator.pop(context) : navigatorPopAlertDialog();

  @override
  Widget build(BuildContext context) {
    // print(temp);
    customDate = CustomDate(
        context: context,
        setStateCallback: dateCallback,
        isClickable: !isDetailPage);
    customDropDown = CustomDropDown(
        context: context,
        setStateCallback: dropDownCallback,
        isClickable: !isDetailPage);
    cakeCountWidget = CakeCountWidget(
        cakeCount: cakeCount,
        callback: cakeCountCallback,
        isDetailPage: isDetailPage);

    return Stack(children: <Widget>[
      Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomPadding: true,
        appBar: setAppbarMethod(),
        body: WillPopScope(
          onWillPop: () => settingOnWillPopMethod(),
          child: GestureDetector(
            onTap: () {
              //If tap ouside, hide keyboard
              FocusScope.of(context).unfocus();
            },
            child: Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.transparent,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    firstLineBuild(),
                    secondLineBuild(),
                    thirdLineBuild(),
                    fourthLineBuild(),
                    fifthLineBuild(),
                    sixthLineBuild(),
                    !isDetailPage ? addButton() : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      TipDialogContainer(duration: const Duration(seconds: 2))
    ]);
  }

  firstLineBuild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _customTextBox(isOrder: true),
        customDate.dateNtimeRow(
            isOrderRow: true,
            controllerCalendar: textEditingControllerOrderDate,
            controllerTimer: textEditingControllerOrderTime,
            dateText: orderDate,
            timeText: orderTime),
      ],
    );
  }

  secondLineBuild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _customTextBox(isOrder: false),
        customDate.dateNtimeRow(
            isOrderRow: false,
            controllerCalendar: textEditingControllerPickUpDate,
            controllerTimer: textEditingControllerPickUpTime,
            dateText: pickUpDate,
            timeText: pickUpTime),
      ],
    );
  }

  thirdLineBuild() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          flex: 1,
          child: customDropDown.selectCakeCategory(
            selectedCakeName,
          ),
        ),
        Flexible(
          flex: 1,
          child: customDropDown.selectCakePrice(
              currentCakeCategory: selectedCakeName,
              cakeList: cakeSizeList,
              selectedCakeSize: selectedCakeSize),
        ),
        Flexible(
            flex: 1,
            child: cakeCountWidget.countWidget(
                isvisible: selectedCakeName != null))
      ],
    );
  }

  fourthLineBuild() {
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
                    enabled: !isDetailPage,
                    controller: textEditingControllerCustomerName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: '성함',
                    ))),
            Flexible(
              child: TextField(
                  enabled: !isDetailPage,
                  controller: textEditingControllerCustomerPhone,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '전화번호',
                  )),
            )
          ])
        ],
      ),
    );
  }

  fifthLineBuild() {
    return Row(children: [
      customDropDown.selectPartTimerDropDown(partTimer),
      payStatus != null
          ? payAndPickUpStatusCheckBox(isPayStatus: true)
          : checkPay(),
      // payAndPickUpStatusCheckBox(isPayStatus: false)
    ]);
  }

  sixthLineBuild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _customTextBox(title: "비고란", import: false),
        _remarkTextField(context),
      ],
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
              // _addData();
              if (!_catchNull()) {
                FocusScope.of(context).unfocus();
                print("pickUp : " + textEditingControllerPickUpTime.text);
                addData();
                dialogProgressIndicator();
              }
            }),
      ),
    );
  }

  addData() async {
    // print(textEditingControllerPickUpDate.text);
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
        remark: textEditingControllerRemark.text.trim(),
        // payStatus: payStatus,
        payInCash: payInCash,
        payInStore: payInStore,
        pickUpStatus: pickUpStatus,
        cakeCount: cakeCount);
    await data.toFireStore(loadDialogCallback);
  }

  navigatorPopAlertDialog() async {
    String result = await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('작성 중'),
          content: Text("변경된 내용은 저장이 되지 않습니다."),
          actions: <Widget>[
            FlatButton(
              child: Text('나가기'),
              onPressed: () {
                int count = 0;
                Navigator.of(context).popUntil(ModalRoute.withName("/"));
              },
            ),
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

  _catchWrite() {
    if (textEditingControllerPickUpDate.text == '') {
      if (textEditingControllerPickUpTime.text == '') {
        if (textEditingControllerCustomerName.text == '') {
          if (textEditingControllerCustomerPhone.text == '') {
            if (textEditingControllerRemark.text == '') {
              return false;
            }
          }
        }
      }
    }
    return true;
  }

  _catchNull() {
    CakeDataError error;
    if (textEditingControllerOrderDate.text == '' ||
        textEditingControllerOrderTime.text == '') {
      error = CakeDataError(
          errorName: "orderDate", errorComment: "예약시간 및 날짜를 선택해주세요");
    } else if (textEditingControllerPickUpDate.text == '' ||
        textEditingControllerPickUpTime.text == '') {
      error = CakeDataError(
          errorName: "pickUpDate", errorComment: "픽업시간 및 날짜를 선택해주세요");
    } else if (selectedCakeName == null) {
      error = CakeDataError(
          errorName: "cakeCategory", errorComment: "케이크 종류를 선택해주세요");
    } else if (selectedCakeSize == null) {
      error =
          CakeDataError(errorName: "cakeSize", errorComment: "케이크 사이즈를 선택해주세요");
    } else if (textEditingControllerCustomerName.text == '') {
      error = CakeDataError(
          errorName: "customerName", errorComment: "주문한 사람의 이름을 입력해주세요");
    } else if (textEditingControllerCustomerPhone.text == '') {
      error = CakeDataError(
          errorName: "customerPhone", errorComment: "주문한 사람의 전화번호를 입력해주세요");
    } else if (partTimer == null) {
      error = CakeDataError(
          errorName: "partTimer", errorComment: "주문받은 사람의 이름을 선택해주세요");
    }
    if (error != null) {
      var snackBar = SnackBar(
          content: Text(
            "${error.errorComment}",
          ),
          duration: Duration(seconds: 1));
      scaffoldKey.currentState.showSnackBar(snackBar);
      return true;
    }
    return false;
  }

  _errorSnackBar(CakeDataError dataError) {
    // final snackBar = SnackBar(content: Text('Are you talkin\' to me?'));
    var snackBar = SnackBar(content: Text("${dataError.errorComment}"));
  }

  dialogProgressIndicator() {
    showDialog(
      context: scaffoldKey.currentContext,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
            onWillPop: () async => true,
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
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
                          "저장 중 입니다.",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        )
                      ])),
            ));
      },
    );
  }

  cakeCountCallback(int count) {
    setState(() {
      cakeCount = count;
    });
  }

  loadDialogCallback({bool isCompleted}) async {
    if (isCompleted == null) {
      Navigator.of(context).pop();
      TipDialogHelper.success("저장 완료!");
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).popUntil(ModalRoute.withName('/'));
    } else {
      Navigator.of(context).pop();
    }
  }

  dateCallback(String param) {
    Map<String, dynamic> arguments = Uri.parse(param).queryParameters;
    //MapKey : isOrder, isCalendar, data

    setState(() {
      if (arguments["isOrder"] == "true") {
        if (arguments["isCalendar"] == "true") {
          textEditingControllerOrderDate..text = arguments["data"];
        } else {
          textEditingControllerOrderTime..text = arguments["data"];
        }
      } else {
        if (arguments["isCalendar"] == "true") {
          textEditingControllerPickUpDate..text = arguments["data"];
        } else {
          textEditingControllerPickUpTime..text = arguments["data"];
        }
      }
    });
  }

  _resetCakePriceList(CakeCategory cakeCategory) {
    cakeSizeList.clear();
    if (cakeCategory != null) {
      for (int i = 0; i < cakeCategory.cakePrice.length; i++) {
        var _checkIntDouble = cakeCategory.cakePrice[i];
        if (_checkIntDouble == double) {
          _checkIntDouble = _checkIntDouble.round();
          print(_checkIntDouble.runtimeType);
        } else if (_checkIntDouble.runtimeType == String) {
          _checkIntDouble = int.tryParse(_checkIntDouble) ?? 0;
        }
        cakeSizeList
            .add(CakeSizePrice(cakeCategory.cakeSize[i], _checkIntDouble));
      }
    }
  }

  dropDownCallback(var parameter,
      {CakeCategory cakeCategory, CakeSizePrice cakePrice}) {
    Map<String, String> arguments = Uri.parse(parameter).queryParameters;
    setState(() {
      if (arguments["parm1"] == "partTimer") {
        partTimer = arguments["parm2"];
      } else if (arguments["parm1"] == "cakeCategory") {
        if (selectedCakeName != cakeCategory) {
          selectedCakeSize = null;
          _resetCakePriceList(cakeCategory);
        }
        selectedCakeName = cakeCategory;
      } else if (arguments["parm1"] == "cakePrice") {
        selectedCakeSize = cakePrice;
      }
    });
  }

  void showAlertDialog(BuildContext context,
      {@required bool isOrderTime}) async {
    String result = await showDialog(
      context: scaffoldKey.currentContext,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: isOrderTime ? Text('주문시간 설정') : Text('픽업시간 설정'),
          content: TimePickerSpinner(
            is24HourMode: true,
            time: DateTime.now(),
            minutesInterval: isOrderTime ? 1 : 5,
            spacing: 50,
            itemHeight: 80,
            isForce2Digits: true,
            onTimeChange: (time) {
              setState(() {
                String _selectTime = DateFormat('kk:mm').format(time);
                isOrderTime
                    ? textEditingControllerOrderTime.text = '$_selectTime'
                    : textEditingControllerPickUpTime.text = '$_selectTime';
              });
            },
          ),
        );
      },
    );
  }

  _remarkTextField(BuildContext context) {
    return Center(
        child: !isDetailPage
            ? Container(
                // width: 350,
                padding: EdgeInsets.only(
                    // bottom: MediaQuery.of(context).viewInsets.bottom,
                    right: 10,
                    left: 10),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.grey)),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: '비고',
                    hintText: '만나서 카드결제 등',
                  ),
                  controller: textEditingControllerRemark,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                child: Text(
                  remarkText != null
                      ? remarkText != ''
                          ? remarkText
                          : '작성된 메모가 없습니다.'
                      : '작성된 메모가 없습니다.',
                  style: TextStyle(height: 1.3),
                ),
              ));
  }

  Widget checkPay({Function snakbarCallback}) {
    return Container(
      margin: EdgeInsets.only(left: 50, top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _customTextBox(title: "매장 결제", import: true),
              Checkbox(
                value: payInStore ?? false,
                onChanged: (value) {
                  setState(() {
                    if (payInStore != null) {
                      payInStore = !payInStore;
                    } else {
                      payInStore = true;
                    }
                    if (payInCash != null) if (payInCash) payInCash = false;
                  });
                  if (snakbarCallback != null) snakbarCallback();
                },
              ),
            ],
          ),
          Column(
            children: [
              _customTextBox(title: "계좌 입금", import: true),
              Checkbox(
                value: payInCash ?? false,
                onChanged: (value) {
                  setState(() {
                    if (payInCash != null) {
                      payInCash = !payInCash;
                    } else {
                      payInCash = true;
                    }
                    if (payInStore != null) if (payInStore) payInStore = false;
                  });
                  if (snakbarCallback != null) snakbarCallback();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  payAndPickUpStatusCheckBox(
      {@required isPayStatus, Function payStatusUpdateFireStore}) {
    bool isDetailPage = payStatusUpdateFireStore != null ? true : false;
    return Container(
      width: MediaQuery.of(context).size.width / 4,
      margin: isDetailPage
          ? EdgeInsets.only(top: 5, right: 5)
          : EdgeInsets.only(left: 10, top: 5, right: 5),
      child: Column(
        children: [
          isPayStatus
              ? _customTextBox(title: "결제 여부", import: true)
              : _customTextBox(title: "픽업 여부", import: true),
          Checkbox(
              value: isPayStatus ? payStatus ?? false : pickUpStatus ?? false,
              onChanged: (value) {
                setState(() {
                  if (isPayStatus) {
                    if (isDetailPage && payStatusUpdateFireStore != null) {
                      payStatusUpdateFireStore("payStatus");
                    }
                    payStatus = payStatus == null ? true : !payStatus;
                  } else {
                    if (isDetailPage && payStatusUpdateFireStore != null) {
                      payStatusUpdateFireStore("pickUpStatus");
                    }
                    pickUpStatus = pickUpStatus == null ? true : !pickUpStatus;
                  }
                });
              })
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

  _customTextBox({bool isOrder, String title, bool import}) {
    return Container(
        padding: EdgeInsets.only(left: _text_MARGIN, top: _text_MARGIN),
        child: _customTitle(
            title: isOrder != null
                ? isOrder
                    ? '주문 날짜'
                    : '픽업 날짜'
                : title,
            important: isOrder != null
                ? isOrder
                    ? false
                    : true
                : import ?? false));
  }
}
