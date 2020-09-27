import 'package:flutter/material.dart';

final List<tempBoardCommentData> testingData = [
  tempBoardCommentData(
      '2020.09.24',
      '이게 바로 이다.',
      20,
      15,
      new tempBoardCommentData('2020.09.21', '이게 바로 댓글이다.', 22, 30,
          tempBoardCommentData('2020.09.21', '이게 바로 댓글이다.', 22, 30, null))),
  tempBoardCommentData('2020.09.21', '이게 댓글이다.', 22, 30, a),
  tempBoardCommentData('2020.09.26', '바로 댓글이다.', 23, 30, null),
  tempBoardCommentData('2020.09.29', '이게 바로 댓글.', 22, 30, null),
  tempBoardCommentData('2020.09.12', '댓글이다.', 26, 30, null),
];
final tempBoardCommentData a =
    tempBoardCommentData('2020.09.21', '이게 댓글이다.', 22, 30, null);

class tempBoardCommentData {
  var commentDate;
  var context;
  int favoriteCount;
  int reportCount;
  tempBoardCommentData underComment;
  tempBoardCommentData(this.commentDate, this.context, this.favoriteCount,
      this.reportCount, this.underComment);
}

class CommentList {
  final BuildContext context;
  CommentList(this.context);

  ListView commentListBuilder() {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: testingData.length,
        itemBuilder: (context, index) =>
            _commentListItemBuilder(context, index));
  }

  Widget _commentListItemBuilder(BuildContext context, int index) {
    // print(tempD.length.toString() + 'length');
    return Card(
        child: Container(
      child: Column(
        children: <Widget>[_setCommentContainer(index: index)],
      ),
    ));
  }

  Widget _setCommentContainer(
      {int index, tempBoardCommentData temp, BuildContext context}) {
    if (testingData[index].commentDate != null) {
      print(testingData[index].commentDate);
      print(testingData[index].underComment);
    } else {
      print('$index');
      print(testingData[index].underComment);
    }

    if (temp != null || testingData[index].underComment != null) {
      print(temp.commentDate);
      return Container(
          padding: EdgeInsets.only(left: 3.0),
          child: Column(
            children: <Widget>[
              Text('hi hi hi'),
              _setCommentContainer(temp: temp)
            ],
          ));
    }
    return Container(padding: EdgeInsets.only(left: 3.0), child: Text('hi hi'));
  }
}
