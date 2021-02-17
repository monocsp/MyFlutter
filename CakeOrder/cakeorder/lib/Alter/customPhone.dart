import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:tip_dialog/tip_dialog.dart';

class CustomerPhone extends StatefulWidget {
  CustomerPhone({Key key}) : super(key: key);

  @override
  _CustomerPhoneState createState() => _CustomerPhoneState();
}

class _CustomerPhoneState extends State<CustomerPhone> {
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  List<Map<String, String>> customerPhoneList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      appBar: AppBar(
        title: Text("About Customer."),
      ),
      body: setFuturebuilder(),
    );
  }

  fetchData() {
    return FirebaseFirestore.instance
        .collection("Cake")
        .orderBy("customerPhone")
        .get();
  }

  setFuturebuilder() {
    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CupertinoActivityIndicator());
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      Text("데이터 불러오기에 실패하였습니다."),
                      Text("${snapshot.hasError}")
                    ],
                  ),
                );
              } else {
                setCustomPhoneList(snapshot);

                if (snapshot.data.size != 0) {
                  if (customerPhoneList.isNotEmpty) {
                    return ListView.builder(
                        itemCount: customerPhoneList.length,
                        itemBuilder: (BuildContext context, int index) {
                          String customerPhone = customerPhoneList[index]
                              .values
                              .toString()
                              .split('')
                              .getRange(
                                  1,
                                  customerPhoneList[index]
                                          .values
                                          .toString()
                                          .length -
                                      1)
                              .join();
                          String customerName = customerPhoneList[index]
                              .keys
                              .toString()
                              .split('')
                              .getRange(
                                  1,
                                  customerPhoneList[index]
                                          .keys
                                          .toString()
                                          .length -
                                      1)
                              .join();
                          return GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  new ClipboardData(text: customerPhone));
                            },
                            child: ListTile(
                              leading: Icon(Icons.person),
                              title: Text(customerName),
                              subtitle: Text(customerPhone),
                              trailing: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(
                                      ClipboardData(text: customerPhone));
                                  _scaffoldGlobalKey.currentState
                                      .showSnackBar(SnackBar(
                                    content: Text(
                                      "$customerName 전화번호 복사 완료!",
                                    ),
                                    duration: Duration(seconds: 1),
                                  ));
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      color: Colors.black),
                                  child: Center(
                                    child: Text(
                                      "COPY",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Center(child: CupertinoActivityIndicator());
                  }
                } else {
                  return Center(
                    child: Text("저장된 데이터가 없습니다!"),
                  );
                }
              }
          }
        });
  }

  setCustomPhoneList(var snapshot) {
    for (int i = 0; i < snapshot.data.size; i++) {
      Map<String, String> customerData = {
        snapshot.data.docs[i]["customerName"]:
            snapshot.data.docs[i]["customerPhone"].toString()
      };
      // if (!customerPhoneList.contains(customerData))
      customerPhoneList.add(customerData);
    }
  }
}
