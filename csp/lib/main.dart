import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'BoardList.dart';
import 'ListView_Pcs.dart';
import 'My_BottomNavigationBarItem.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:swipedetector/swipedetector.dart';
import 'BoardContent.dart';

class tempTitleData {
  var title;
  var subtitle;
  int commentCount;
  int favoriteCount;
  var date;
  tempTitleData(this.title, this.subtitle, this.commentCount,
      this.favoriteCount, this.date);
}

final int GENERALBOARD_CODE = 10;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Listview',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  GeneralBoard _generalBoard;
  final RefreshController _refreshController = RefreshController();
  int _previousIndex;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    _generalBoard = new GeneralBoard();
    return Scaffold(
        drawer: new Drawer(
            child: new BoardList(context).buildBoardListView(context)),
        appBar: AppBar(
          title: Text('listview'),
        ),

        //Custom Refresh indicator widget
        //https://medium.com/flutter-community/how-to-create-your-own-pull-to-refresh-custom-refresh-indicator-widget-in-flutter-a3aa4e8bb42d
        //Refresh method : https://protocoderspoint.com/flutter-pull-to-refresh-using-smartrefresh-library/
        body: testBody(context),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.pop(context);
            }),
        bottomNavigationBar:
            CustomBottomNavigationBar().customBar(selectedIndex));
  }

  Widget mainBody(BuildContext context) {
    DragStartDetails startDragDetail;
    DragEndDetails endDragDetail;
    return GestureDetector(
      onHorizontalDragStart: (details) {
        startDragDetail = details;
        print(details);
      },
      child: SwipeDetector(
        child: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          header: WaterDropMaterialHeader(
            backgroundColor: Colors.grey,
          ),
          onRefresh: () => pullToRefresh(GENERALBOARD_CODE),
          child: new GeneralBoard().buildListView(),
        ),
        onSwipeLeft: () {
          // if (startDragDetail.globalPosition.dx < 300) {
          //   print('hello');
          // }
          print('hi $startDragDetail');
          print('hello');
        },
      ),

      onHorizontalDragUpdate: (details) {
        print(details.globalPosition.dx);
      },
      // onHorizontalDragEnd: (details) {
      //   endDragDetail = details;
      //   if(startDragDetail.globalPosition.dx){
      //     endDragDetail.
      //   }

      // },

      // onPanUpdate: (details) {
      //   if (details.delta.dx < 0) {
      //     print('hi');
      //   }
      // },
    );
  }

  Widget testBody(BuildContext context) {
    return SwipeDetector(
      child: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        header: WaterDropMaterialHeader(
          backgroundColor: Colors.grey,
        ),
        onRefresh: () => pullToRefresh(GENERALBOARD_CODE),
        child: _generalBoard.buildListView(),
      ),
      onSwipeLeft: () {
        GestureDetector();
        _previousIndex = _generalBoard.previousIndex;
        print('left swipe');
        if (_generalBoard.previousIndex != null) {
          Navigator.of(context).push(CupertinoPageRoute(
              fullscreenDialog: false,
              builder: (context) => Board(index: _generalBoard.previousIndex)));
        }
      },
      swipeConfiguration: SwipeConfiguration(
          horizontalSwipeMaxHeightThreshold: 10, horizontalSwipeMinVelocity: 0),
    );
  }

  void onItemTapped(int index) {}
  //Pull To Refresh Method
  Future pullToRefresh(var CurrentBoardCode) async {
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }
}
