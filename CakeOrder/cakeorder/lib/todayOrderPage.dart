import 'package:flutter/material.dart';

class TodayList extends StatefulWidget {
  @override
  _TodayListState createState() => _TodayListState();
}

class _TodayListState extends State<TodayList> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(100),
                child: AppBar(
                  title: Center(child: Text('hihi')),
                  bottom: TabBar(
                    indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(width: 5.0),
                        insets: EdgeInsets.symmetric(horizontal: 16.0)),
                    onTap: (index) {},
                    tabs: [
                      Tab(
                        icon: Icon(Icons.book),
                      ),
                      Tab(
                        icon: Icon(Icons.wheelchair_pickup),
                      )
                    ],
                  ),

                  // bottom:
                ),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/AddOrder');
                },
                child: Icon(Icons.add),
              ),
              body: TabBarView(children: [
                Center(
                    child: Text(
                  "0",
                  style: TextStyle(fontSize: 40),
                )),
                Center(
                    child: Text(
                  "1",
                  style: TextStyle(fontSize: 40),
                ))
              ])),
        ));
  }
}
