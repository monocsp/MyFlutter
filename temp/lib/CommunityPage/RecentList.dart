import 'package:flutter/material.dart';

const String TRENDINGDOWN = 'SHORT';
const String TRENDINGFLAT = 'HOLD';
const String TRENDINGUP = 'LONG';
const bool AGREE = true;
const bool DISAGREE = false;

class RecentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, index) =>
            _buildListCard(context, index));
  }

  _buildListCard(BuildContext context, int index) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(1.0),
      child: InkWell(
        splashColor: Colors.grey,
        onTap: () {},
        child: Column(
          children: [_listDesignContainer()],
        ),
      ),
    ));
  }

  _listDesignContainer() {
    return Container(
      child: Column(
        children: <Widget>[
          _recentListCard_FirstColumn(),
          _recentListCard_SecondColumn(),
          _recentListCard_ThirdColumn()
        ],
      ),
    );
  }

  _recentListCard_FirstColumn() {
    return Row(
      children: <Widget>[
        _classificationContainer(text: '삼성전자'),
        _opinionIcon(opinion: TRENDINGUP),
        Spacer(),
        _commentCountContainer()
      ],
    );
  }

  _recentListCard_SecondColumn() {
    return Row(
      children: <Widget>[
        _classificationContainer(text: '삼성전자'),
      ],
    );
  }

  _recentListCard_ThirdColumn() {
    return Row(
      children: <Widget>[
        _classificationContainer(text: '삼성전자'),
        _opinionIcon(opinion: TRENDINGUP),
        Spacer(),
        _agreeORDisagreeContainer(condition: AGREE),
        _agreeORDisagreeContainer(condition: DISAGREE)
      ],
    );
  }

  _classificationContainer({@required String text, TextStyle textStyle}) {
    return Container(
      color: Colors.yellowAccent,
      child: Center(
        child: Text(
          text,
          style: textStyle ??
              TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _opinionIcon({@required String opinion}) {
    if (opinion == TRENDINGDOWN)
      return Icon(
        Icons.trending_down,
        color: Colors.blue,
      );
    else if (opinion == TRENDINGFLAT)
      return Icon(Icons.trending_flat);
    else if (opinion == TRENDINGUP)
      return Icon(
        Icons.trending_up,
        color: Colors.red,
      );
  }

  Widget _iconAndTextContainer() {
    return Container(child: Row(children: <Widget>[],),);
  }

  Widget _commentCountContainer({var commentCount}) {
    var _commentStyle;
    return Container(
      child: Row(
        children: <Widget>[
          Icon(Icons.comment),
          Container(
            padding: EdgeInsets.only(right: 2.0),
            child: Text(
              commentCount ?? '0',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _agreeORDisagreeContainer({@required bool condition, var agreecount}) {
    var _icons;
    var _textStyle;
    if (condition) {
      _icons = Icon(
        Icons.thumb_up,
        color: Colors.red,
        size: 20,
      );
      _textStyle = TextStyle(color: Colors.red, fontSize: 15);
    } else {
      _icons = Icon(
        Icons.thumb_down,
        color: Colors.blue,
        size: 20,
      );
      _textStyle = TextStyle(color: Colors.blue, fontSize: 15);
    }

    return Container(
      padding: EdgeInsets.all(3.0),
      child: Row(
        children: <Widget>[
          Container(padding: EdgeInsets.only(right: 2.0), child: _icons),
          Text(agreecount ?? '0',
              style: _textStyle) //?? : if agreecount is null, print '0'
        ],
      ),
    );
  }
}
