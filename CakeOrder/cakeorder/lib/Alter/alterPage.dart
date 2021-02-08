import 'package:flutter/material.dart';

class AlterPage extends StatefulWidget {
  AlterPage({Key key}) : super(key: key);

  @override
  _AlterPageState createState() => _AlterPageState();
}

class _AlterPageState extends State<AlterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text("Setting.")),
        ),
        body: _selectionButtonMethod());
  }

  _selectionButtonMethod() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            child: GestureDetector(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: Icon(
                    Icons.cake,
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text("Cake Setting",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                            )),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 5),
                        child: Text("케이크 종류, 사이즈 및 가격을 설정합니다.",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            )),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/SettingPartTimer');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Icon(Icons.person, color: Colors.grey),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("PartTimer Setting",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text("아르바이트를 설정합니다.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
          Container(
              margin: EdgeInsets.only(left: 10, right: 10, top: 20, bottom: 20),
              child: GestureDetector(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Stack(alignment: Alignment.center, children: [
                        Icon(Icons.calendar_today, color: Colors.grey),
                        Icon(
                          Icons.money,
                          size: 18,
                        )
                      ]),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text("Report",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                )),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 5),
                            child: Text("매출현황을 볼 수 있습니다.",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  _cakeMapWidgetMethod() {}

  _customTextBox(String text) {
    return Container(
        margin: EdgeInsets.all(10),
        child: Text(
          text ?? '',
          style: TextStyle(
              color: Colors.redAccent,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ));
  }
}
