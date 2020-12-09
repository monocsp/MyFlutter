import 'package:flutter/material.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'HomePage.dart';
import 'MarketPage.dart';
import 'CommunityPage/CommunityPage.dart';
import 'MyImpoPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _MainPage(),
    );
  }
}

class _MainPage extends StatefulWidget {
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  final _bottomWidgetList = [
    HomePage(),
    CommunityPage(),
    MarketPage(),
    MyImpoPage()
  ];
  int currentIndex;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = 0;
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: _bottomBubbleNaviBar(),
      //IndexedStack is keep pageState when you click others bottombar
      body: IndexedStack(index: currentIndex, children: <Widget>[
        HomePage(),
        CommunityPage(),
        MarketPage(),
        MyImpoPage()
      ]),
    ));
  }

  Widget _bottomBubbleNaviBar() {
    return BubbleBottomBar(
      hasNotch: true,
      opacity: .2,
      currentIndex: currentIndex,
      onTap: changePage,
      borderRadius: BorderRadius.vertical(
          top: Radius.circular(
              16)), //border radius doesn't work when the notch is enabled.
      elevation: 8,
      items: <BubbleBottomBarItem>[
        BubbleBottomBarItem(
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.home,
              color: Colors.red,
            ),
            title: Text("Home")),
        BubbleBottomBarItem(
            backgroundColor: Colors.deepPurple,
            icon: Icon(
              Icons.view_list,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.view_list,
              color: Colors.deepPurple,
            ),
            title: Text("Community")),
        BubbleBottomBarItem(
            backgroundColor: Colors.indigo,
            icon: Icon(
              Icons.trending_up,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.trending_up,
              color: Colors.indigo,
            ),
            title: Text("Market")),
        BubbleBottomBarItem(
            backgroundColor: Colors.green,
            icon: Icon(
              Icons.person_outline,
              color: Colors.black,
            ),
            activeIcon: Icon(
              Icons.person,
              color: Colors.green,
            ),
            title: Text("Menu"))
      ],
    );
  }
}

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Center(
                child: Text(
          'First Activity Screen',
          style: TextStyle(fontSize: 21),
        ))));
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Center(
                child: Text(
          'Second Activity Screen',
          style: TextStyle(fontSize: 21),
        ))));
  }
}

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Center(
                child: Text(
          'Third Activity Screen',
          style: TextStyle(fontSize: 21),
        ))));
  }
}
