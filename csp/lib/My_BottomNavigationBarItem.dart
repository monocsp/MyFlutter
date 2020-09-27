import 'package:flutter/material.dart';

class CustomBottomNavigationBar {
  CustomBottomNavigationBar();
  BottomNavigationBar customBar(var selectedIndex) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time), title: Text('최신순')),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), title: Text('공감순')),
          BottomNavigationBarItem(icon: Icon(Icons.comment), title: Text('댓글순'))
        ],
        currentIndex: selectedIndex,
        fixedColor: Colors.grey);
  }
}
