import 'package:flutter/material.dart';
import '../main.dart';
import 'RecentList.dart';

class CommunityPage extends StatefulWidget {
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  ScrollController _scrollController;
  // TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = new ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
            // controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) =>
                    _communityPageTabBarDesign(context, innerBoxIsScrolled),
            body: _communityPageTabBarView()),
      ),
    ));
  }

  List<Widget> _communityPageTabBarDesign(
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
              _tabBarTextDesign(text: "최신순"),
              _tabBarTextDesign(text: "추천순"),
              _tabBarTextDesign(text: "오늘의"),
            ]),
      ),
    ];
  }

  _communityPageTabBarView() {
    return TabBarView(
      children: <Widget>[
        RecentList(),
        Container(
          color: Colors.black,
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
