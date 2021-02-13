import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CakeSetting extends StatefulWidget {
  CakeSetting({Key key}) : super(key: key);

  @override
  _CakeSettingState createState() => _CakeSettingState();
}

class _CakeSettingState extends State<CakeSetting> {
  bool createButton;
  @override
  void initState() {
    super.initState();
    createButton = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cake Setting"),
      ),
      body: setFuturebuilder(),
    );
  }

  Future fetchData() {
    final _db = FirebaseFirestore.instance;

    return _db.collection("CakeList").get();
  }

  Widget setFuturebuilder() {
    return FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(
                child: CupertinoActivityIndicator(),
              );
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
                var cakeListSnapshot = snapshot.data.docs;
                return ListView.builder(
                    itemCount: snapshot.data.size,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        onTap: () {},
                        leading: Icon(Icons.cake_outlined),
                        title: Text(cakeListSnapshot[index].id),
                        subtitle: Text(cakeListSnapshot[index]["CakePrice"]
                            .toString()
                            .split('')
                            .getRange(
                                1,
                                cakeListSnapshot[index]["CakePrice"]
                                        .toString()
                                        .length -
                                    1)
                            .join()),
                      );
                    });
              }
          }
        });
  }

  // _createCakeData() {
  //   if (createButton) {
  //     return Container(
  //         height: 80,
  //         child: Center(
  //           child: IconButton(
  //             icon: Icon(Icons.add),
  //             onPressed: () {
  //               setState(() {
  //                 createButton = false;
  //               });
  //             },
  //           ),
  //         ));
  //   } else {
  //     return Container(
  //         decoration: new BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.all(Radius.circular(10)),
  //             border: Border.all(width: 1, color: Colors.black12)),
  //         margin: EdgeInsets.only(left: 50, right: 50, top: 20, bottom: 20),
  //         padding: EdgeInsets.only(left: 10),
  //         child: TextField(
  //           decoration: InputDecoration(
  //               border: InputBorder.none,
  //               hintText: '이름을 작성하세요.',
  //               hintStyle: TextStyle(color: Colors.grey[300])),
  //           cursorColor: Colors.blue,
  //           maxLines: 1,
  //           textInputAction: TextInputAction.go,
  //           onSubmitted: (value) {
  //             setState(() {
  //               partTimerProvider.add(value);
  //               _firestoreDataUpdate(value, isUndo: false);
  //               createButton = true;
  //               textEditingController.clear();
  //             });
  //           },
  //           controller: textEditingController,
  //         ));
  //   }
  // }
}
