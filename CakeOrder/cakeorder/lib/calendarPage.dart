import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'ProviderPackage/cakeDataClass.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>
    with TickerProviderStateMixin {
  List<CakeDataCalendar> thisMonthCakeDataList;
  Map<DateTime, List> _events;
  List<dynamic> _selectedEvents;
  AnimationController _animationController;
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    // initEventData();
    final _selectedDay = DateTime.now();
    _events = {};

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();
  }

  Future initEventData() async {
    var a;
    if (thisMonthCakeDataList != null) {
      thisMonthCakeDataList.forEach((element) {
        DateTime _pickUpdate = element.pickUpDate;
        DateTime _day =
            DateTime(_pickUpdate.year, _pickUpdate.month, _pickUpdate.day);

        if (a == _day) {
          _events.update(_day, (value) {
            List<dynamic> _temp = [];
            _temp.addAll(value);
            _temp.add(element);
            return _temp;
          });
        } else {
          print("hi");
          _events.addAll({
            _day: [element]
          });
        }
        a = _day;
      });
    } else {}
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {}

  void _onCalendarCreated(
      DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('hi'),
        ),
        body: _builder());
  }

  _builder() {
    thisMonthCakeDataList = Provider.of<List<CakeDataCalendar>>(context);
    initEventData();
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        _buildTableCalendar(),
        const SizedBox(height: 8.0),
        Expanded(child: _buildEventList()),
      ],
    );
  }

  // Simple TableCalendar configuration (using Styles)
  Widget _buildTableCalendar() {
    return _events != null
        ? TableCalendar(
            calendarController: _calendarController,
            events: _events,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              selectedColor: Colors.deepOrange[400],
              todayColor: Colors.deepOrange[200],
              markersColor: Colors.brown[700],
              outsideDaysVisible: false,
            ),
            headerStyle: HeaderStyle(
              formatButtonTextStyle:
                  TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
              formatButtonDecoration: BoxDecoration(
                color: Colors.deepOrange[400],
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            onDaySelected: _onDaySelected,
            onVisibleDaysChanged: _onVisibleDaysChanged,
            onCalendarCreated: _onCalendarCreated,
          )
        : Center(
            child: CupertinoActivityIndicator(),
          );
  }

  Widget _buildEventList() {
    return _events != null
        ? ListView(
            children: _selectedEvents.map((event) {
              var _pickupdate = event.pickUpDate.toString().split('');
              _pickupdate.removeRange(
                  _pickupdate.length - 7, _pickupdate.length);

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 0.8),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  leading: Icon(Icons.cake),
                  title: Text(event.cakeCategory +
                      event.cakeSize +
                      " X" +
                      event.cakeCount.toString() +
                      "개 "),
                  subtitle: Text(_pickupdate.join()),
                  onTap: () => print('${event.cakeCategory} tapped!'),
                ),
              );
            }).toList(),
          )
        : Center(
            child: Text("hello"),
          );
  }
}
