import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'BoardList.dart';
import 'ListView_Pcs.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:swipedetector/swipedetector.dart';
import 'BoardContent.dart';
import 'BoardPersonal.dart';
import 'BoardFloatingButton.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:badges/badges.dart';
import 'FirstPageView.dart';
import 'SecondPageView.dart';

const String page1 = 'Page 1';
const String page2 = 'Page 2';
const int PERSONALIMPOBOARDIndex = 3;
const int TODAYFAVORITEBOARDIndex = 1;
const int BOARDPERSONALIMPOIndex = 2;
const int LISTBOARDIndex = 0;

class tempTitleData {
  var title;
  var subtitle;
  int commentCount;
  int favoriteCount;
  var date;
  tempTitleData(this.title, this.subtitle, this.commentCount,
      this.favoriteCount, this.date);
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TabPage(),
    );
  }
}

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int selectedIndex = 0;
  int badge = 0;
  var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
  double gap = 10;

  PageController controller = PageController();
  List<Widget> widgets = [
    Blue(),
    FirstPageView(),
    SecondPageView(),
    BoardImpo()
  ];

  @override
  void initState() {
    super.initState();

    var padding = EdgeInsets.symmetric(horizontal: 18, vertical: 5);
    double gap = 10;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        extendBody: true,

        body: PageView.builder(
          onPageChanged: (page) {
            setState(() {
              selectedIndex = page;
              badge = badge + 1;
            });
          },
          controller: controller,
          //Set PageView
          itemBuilder: (context, position) {
            return widgets[position];
          },
          itemCount: 4, // Can be null
        ),
        // backgroundColor: Colors.green,
        // body: Container(color: Colors.red,),
        bottomNavigationBar: SafeArea(
          child: Container(
            //Margin : Set botton navigation bar size
            //horizontal Size is (Left-End point to NaviBar Start point + NaviBar End point to RightEnd Point)
            //Vertical is bottom padding
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(100)),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: -10,
                      blurRadius: 60,
                      color: Colors.black.withOpacity(.4),
                      offset: Offset(0, 25))
                ]),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3),
              child: GNav(
                  curve: Curves.easeOutExpo,
                  duration: Duration(milliseconds: 900),
                  tabs: [
                    GButton(
                      gap: gap,
                      iconActiveColor: Colors.purple,
                      iconColor: Colors.black,
                      textColor: Colors.purple,
                      backgroundColor: Colors.purple.withOpacity(.2),
                      iconSize: 24,
                      padding: padding,
                      icon: LineIcons.home,
                      // textStyle: t.textStyle,
                      text: 'Home',
                    ),
                    GButton(
                      gap: gap,
                      iconActiveColor: Colors.pink,
                      iconColor: Colors.black,
                      textColor: Colors.pink,
                      backgroundColor: Colors.pink.withOpacity(.2),
                      iconSize: 24,
                      padding: padding,
                      icon: LineIcons.heart_o,
                      leading: selectedIndex == 1 || badge == 0
                          ? null
                          : Badge(
                              badgeColor: Colors.red.shade100,
                              elevation: 0,
                              position:
                                  BadgePosition.topEnd(top: -12, end: -12),
                              badgeContent: Text(
                                badge.toString(),
                                style: TextStyle(color: Colors.red.shade900),
                              ),
                              child: Icon(
                                LineIcons.heart_o,
                                color: selectedIndex == 1
                                    ? Colors.pink
                                    : Colors.black,
                              )),

// textStyle: t.textStyle,
                      text: 'Likes',
                    ),
                    GButton(
                      gap: gap,
                      iconActiveColor: Colors.amber[600],
                      iconColor: Colors.black,
                      textColor: Colors.amber[600],
                      backgroundColor: Colors.amber[600].withOpacity(.2),
                      iconSize: 24,
                      padding: padding,
                      icon: LineIcons.search,
// textStyle: t.textStyle,
                      text: 'Search',
                    ),
                    GButton(
                      gap: gap,
                      iconActiveColor: Colors.amber[600],
                      iconColor: Colors.black,
                      textColor: Colors.amber[600],
                      backgroundColor: Colors.amber[600].withOpacity(.2),
                      iconSize: 24,
                      padding: padding,
                      icon: Icons.person_outline,
// textStyle: t.textStyle,
                      text: 'Impo',
                    )
                  ],
                  selectedIndex: selectedIndex,
                  onTabChange: (index) {
                    // _debouncer.run(() {

                    print(index);
                    setState(() {
                      selectedIndex = index;
                      // badge = badge + 1;
                    });
                    controller.jumpToPage(index);
                    // });
                  }),
            ),
          ),
        ),
      ),
    );
  }
}

class Red extends StatefulWidget {
  @override
  _RedState createState() => _RedState();
}

class _RedState extends State<Red> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}

class Blue extends StatefulWidget {
  @override
  _BlueState createState() => _BlueState();
}

class _BlueState extends State<Blue> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueAccent,
    );
  }
}

class Yellow extends StatefulWidget {
  @override
  _YellowState createState() => _YellowState();
}

class _YellowState extends State<Yellow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellowAccent,
    );
  }
}
