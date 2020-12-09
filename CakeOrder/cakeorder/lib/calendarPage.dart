import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
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
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/AddOrder');
                },
                child: Icon(Icons.add),
              ),
              body: TabBarView(children: [
                Center(child: SfDateRangePicker()),
                Center(
                    child: Text(
                  "1",
                  style: TextStyle(fontSize: 40),
                ))
              ])),
        ));
  }
}
