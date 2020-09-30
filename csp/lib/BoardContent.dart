import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:meta/meta.dart';
import 'package:cupertino_back_gesture/cupertino_back_gesture.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'CommentInBoardContent.dart';

final String IOSTHEME = 'IOS';
final String ANDROIDTHEME = 'Android';

class Board extends StatelessWidget {
  final int index;
  final String boardName;
  //index is not null and must have to get index
  Board({@required this.index, this.boardName}) : assert(index != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$index'),
      ),
      body: _boardContent(context),
    );
  }

  Widget _boardContent(BuildContext context) {
    final RefreshController _refreshController = new RefreshController();
    return SmartRefresher(
        enablePullDown: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: () async {
          await Future.delayed(Duration(seconds: 1));
          _refreshController.refreshCompleted();
        },
        child: Container(
          // alignment: AlignmentA,
          child: Column(children: <Widget>[
            //Title Container
            Container(
              child: Row(children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 5),
                    child: Text('Title',
                        maxLines: 1,
                        style: new TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)))
              ]),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5,
                    offset: Offset(0, 1))
              ]),
            ),

            //Date Container
            Container(
              child: Container(
                  margin: EdgeInsets.only(top: 5),
                  // alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end, //Start from Right
                    children: <Widget>[
                      IconTheme(
                        child: Icon(Icons.access_time, size: 20),
                        data: new IconThemeData(color: Colors.grey),
                      ),
                      Text(
                        'Date',
                        style: new TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Text(
                        ' | ',
                        style: new TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      IconTheme(
                        child: Icon(
                          Icons.remove_red_eye,
                          size: 20,
                        ),
                        data: new IconThemeData(color: Colors.grey),
                      ),
                      Text(
                        'watch',
                        style: new TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ],
                  )),
            ),
            Flexible(
              child: Column(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      child: GestureDetector(
                          onDoubleTap: () {
                            _showFavoriteAlertDialog(context);
                          },
                          child: SingleChildScrollView(
                              // controller: controller,
                              // scrollDirection: Axis.vertical,
                              child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Colors.grey, width: 5.0))),
                                  child: Text(
                                      'ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야너야'),
                                ),
                                Container(
                                    child: CommentList(context)
                                        .setCommentContainer())
                              ],
                            ),
                          ))
                          // child: Container(
                          //   height: double.infinity,
                          //   child: Column(
                          //     crossAxisAlignment:
                          //         CrossAxisAlignment.stretch,
                          //     children: <Widget>[
                          //       Flexible(
                          //         child: Text(
                          //             'ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야ㅊㄴㅇ러댜닝ㄹㅇ너란어ㅣ라너아러ㅣ나러아니러ㅏㄴㅇㄹㅊefsdijflewijfslkdjflksdjflkjsdk ㄴ어라ㅣ넝라너ㅣ아러 ㄴㅇfsdfjlsejfjkjsdlkfsj dfsㅇ러낭리너야너야'),
                          //       )
                          // ],

                          // Container(
                          //     child: CommentList(context)
                          //         .commentListBuilder())

                          ),
                    ),
                  ),
                ],
              ),
            ),
            ////favorite count, scrap count container
            // Flexible(child: CommentList(context).commentListBuilder()),

            // //Comment Listview
            // _boardContentCommentList()
          ]),
        ));
  }

  _showFavoriteAlertDialog(BuildContext context, {String setting}) {
    var alert;
    Widget favoriteConfirmButton = FlatButton(
      child: Text('공감하기'),
      onPressed: () {},
    );
    Widget favoriteCancelButton = FlatButton(
      child: Text('취소'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    if (setting == 'IoS') {
      alert = CupertinoAlertDialog(
        title: Text('공감하기'),
        content: Text('공감하시겠습니까?'),
        actions: [favoriteCancelButton, favoriteConfirmButton],
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      );
    } else if (setting == 'Android' || setting == null) {
      alert = AlertDialog(
        title: Text('공감하기'),
        content: Text('공감하시겠습니까?'),
        actions: [favoriteCancelButton, favoriteConfirmButton],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      );
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }
}
