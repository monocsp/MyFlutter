import 'package:flutter/material.dart';
import 'dart:math' as math;

final List<tempBoardCommentData> testingData = [
  tempBoardCommentData('2020.09.24', '이게 바로 이다.', 20, 15, 5),
  // tempBoardCommentData('2020.09.21', '이게 댓글이다.', 22, 30, 0),
  // tempBoardCommentData('2020.09.26', '바로 댓글이다.', 23, 30, 0),
  // tempBoardCommentData('2020.09.29', '이게 바로 댓글.', 22, 30, 0),
  // tempBoardCommentData('2020.09.12', '댓글이다.', 26, 30, 0),
];
final bool FIRSTCOMMENT = true;
final double COMMENTCONTAINERHEIGHT = 50;
final double COMMENTBOARDERLINEWiDTH = 3.0;

class tempBoardCommentData {
  var commentDate;
  var context;
  int favoriteCount;
  int reportCount;
  int underComment;
  tempBoardCommentData(this.commentDate, this.context, this.favoriteCount,
      this.reportCount, this.underComment);
}

class CommentList {
  final BuildContext context;
  CommentList(this.context);
  Widget setCommentContainer() {
    return Container(
        child: Column(children: <Widget>[
      _setCommentContainer(firstComment: FIRSTCOMMENT),
      Container(
        child: Column(
          children: _setUnderComment(underCommentCount: 2),
        ),
      )
    ]));
  }

  List<Widget> _setUnderComment(
      {@required int underCommentCount, BuildContext context}) {
    // int _underCommentLength = testingData[index].underComment;
    return new List<Widget>.generate(underCommentCount,
        (index) => _setCommentContainer(firstComment: !FIRSTCOMMENT));
  }

  Container _setCommentContainer({@required bool firstComment}) {
    BoxDecoration initDecoration;
    if (!firstComment) {
      initDecoration = BoxDecoration(
        color: Colors.grey,
      );
    } else {
      initDecoration = BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Colors.grey, width: COMMENTBOARDERLINEWiDTH)));
    }
    return Container(
        height: COMMENTCONTAINERHEIGHT,
        decoration: initDecoration,
        child: _setInnerColumn(firstComment: firstComment));
  }

  Widget _setInnerColumn({@required bool firstComment}) {
    // var paddingSize = EdgeInsets.only(left: 0);
    var containerColumnValue = Column(
      children: <Widget>[
        // _setCommentIcon(firstComment: firstComment),
        _setColumnInnerFirstRow(firstComment: firstComment),
        _setColumnInnerSecondRow(firstComment: firstComment)
      ],
    );
    if (!firstComment) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
              child: Transform(
            alignment: Alignment.topLeft,
            transform: Matrix4.rotationY(math.pi),
            child: Icon(
              Icons.keyboard_return,
              size: 20,
            ),
          )),
          containerColumnValue,
        ],
      );
    } else {
      return containerColumnValue;
    }
  }

  _setColumnInnerFirstRow({@required bool firstComment}) {
    // if(comment writer and poster writer same){
    // nameTextColor = dateTextColor = Colors.green;
    // writter = '작성자';
    // }
    var nameTextColor = Colors.black;
    var dateTextColor = Colors.grey;
    var writter = '익친 1';
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        ////Setting Text For Distinguish Name
        Container(
          padding: EdgeInsets.only(top: 3.0, left: 3.0),
          child: Text(
            writter,
            style: TextStyle(color: nameTextColor, fontWeight: FontWeight.bold),
          ),
        ),
        //Setting Text For Date
        Container(
            padding: EdgeInsets.only(top: 3.0, right: 2.0),
            child: Text(
              '2020.09.24',
              style: TextStyle(color: dateTextColor),
            ))
      ],
    );
  }

  Widget _setColumnInnerSecondRow({@required bool firstComment}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            //     child: Transform(
            //   alignment: Alignment.center,
            //   transform: Matrix4.rotationY(math.pi),
            //   child: Icon(Icons.keyboard_return),
            // )
            child: Text('hsihdifhi'))
      ],
    );
  }

  Widget _setCommentIcon() {
    return Container(
        color: Colors.white,
        width: 100,
        child: Transform(
          alignment: Alignment.topLeft,
          transform: Matrix4.rotationY(math.pi),
          child: Icon(
            Icons.keyboard_return,
            size: 5,
          ),
        ));
  }
}
