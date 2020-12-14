import 'package:cakeorder/ProviderPackage/cakeList.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:cakeorder/calendarPage.dart';
import 'package:cakeorder/todayOrderPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'ProviderPackage/myprovider.dart';
import 'customBottomNavi.dart';
import 'checkingOS.dart';
import 'todayOrderPage.dart';
import 'cakeOrderRoute.dart';
import 'calendarPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(CakeOrderApp());
}

class CakeOrderApp extends StatefulWidget {
  @override
  _CakeOrderAppState createState() => _CakeOrderAppState();
}

class _CakeOrderAppState extends State<CakeOrderApp> {
  DatabaseProvider db = DatabaseProvider(); //get provider

  @override
  var _os = CurrentOSCheck.instance;
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  List<Widget> _widgetOptions = <Widget>[
    TodayList(),
    Text(
      'Index 1: Likes',
      style: optionStyle,
    ),
    CalendarPage(),
    Text(
      'Index 3: Profile',
      style: optionStyle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<List<dynamic>>.value(
            value: db.getPartTimer(),
            catchError: (context, error) => null,
          ),
          StreamProvider<List<CakeCategory>>.value(
            value: db.getCakeCategory(),
            catchError: (context, error) {
              print(error);
              return null;
            },
          )
        ],
        child: _os['Android']
            ? MaterialApp(
                home: _materialAppScaffold(context),
                theme: ThemeData(primaryColor: Colors.white),
                initialRoute: '/',
                onGenerateRoute: CakeOrderRouteGenerator.generateRoute,
              )
            : CupertinoApp());
  }

  _materialAppScaffold(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            bottomNavigationBar: CustomBottomNavi().bottomNavigationContainer(
                selectedIndex: _selectedIndex,
                setStateCallback: changeNaviIndex)));
  }

  void changeNaviIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
