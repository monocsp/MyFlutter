import 'package:flutter/material.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class MarketPage extends StatefulWidget {
  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  ScrollController _scrollController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
            length: 2,
            child: Scaffold(
              body: NestedScrollView(
                  // controller: _scrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) =>
                          _marketPageTabBarDesign(context, innerBoxIsScrolled),
                  body: _marketPageTabBarView()),
            )));
  }

  List<Widget> _marketPageTabBarDesign(
      BuildContext context, bool innerBoxIsScrolled) {
    return <Widget>[
      new SliverAppBar(
        backgroundColor: Colors.redAccent,
        title: new Text("widget.title"),
        pinned: true,
        floating: true,
        forceElevated: innerBoxIsScrolled,
        bottom: TabBar(
            labelColor: Colors.redAccent,
            unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white),
            tabs: [
              _tabBarTextDesign(text: "Index"),
              _tabBarTextDesign(text: "Stock")
            ]),
      ),
    ];
  }

  _marketPageTabBarView() {
    return TabBarView(
      children: <Widget>[
        Container(
          color: Colors.red,
        ),
        Container(
          color: Colors.black,
        )
      ],
      // controller: _tabController,
    );
  }

  _tabBarTextDesign({@required String text, var textStyle}) {
    return Tab(
      child: Align(
          alignment: Alignment.center,
          child: Text(text,
              style: textStyle ??
                  TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
    );
  }
}
