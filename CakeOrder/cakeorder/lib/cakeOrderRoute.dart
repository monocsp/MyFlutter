import 'package:cakeorder/OrderListPackage/todayOrderPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'addOrderPackage/addOrder.dart';
import 'checkingOS.dart';
import 'main.dart';

class CakeOrderRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Widget _pageWidget;
    var _name = settings.name.replaceFirst('/', '');
    switch (_name) {
      case 'home':
        _pageWidget = CakeOrderApp();
        break;
      case 'AddOrder':
        _pageWidget = AddOrder();
        break;
      case 'temp':
        _pageWidget = OrderPage();
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
