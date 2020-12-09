import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'addOrderPackage/addOrder.dart';
import 'checkingOS.dart';

class CakeOrderRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget _pageWidget;
    final args = settings.arguments;
    var _name = settings.name.replaceFirst('/', '');
    switch (_name) {
      case 'AddOrder':
        _pageWidget = AddOrder();
        break;
    }
    return CurrentOSCheck.instance['Android']
        ? MaterialPageRoute(builder: (context) => _pageWidget)
        : CupertinoPageRoute(
            builder: (context) => _pageWidget,
          );
  }
}
