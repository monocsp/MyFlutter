import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'addOrderPackage/addOrder.dart';
import 'addOrderPackage/test.dart';
import 'checkingOS.dart';
import 'main.dart';
import 'OrderListPackage/detailPage.dart';

class CakeOrderRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    Widget _pageWidget;
    var _name = settings.name.replaceFirst('/', '');
    switch (_name) {
      case 'home':
        _pageWidget = CakeOrderApp();
        break;
      case 'AddOrder':
        _pageWidget = AddOrder();
        break;
      case 'DetailPage':
        _pageWidget = DetailPage();
    }
    return CurrentOSCheck.instance['Android']
        ? MaterialPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (context) => _pageWidget)
        : CupertinoPageRoute(
            settings: RouteSettings(name: settings.name),
            builder: (context) => _pageWidget,
          );
  }
}
