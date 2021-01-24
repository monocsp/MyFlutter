import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'addOrderPackage/addOrder.dart';
import 'addOrderPackage/test.dart';
import 'checkingOS.dart';
import 'main.dart';
import 'OrderListPackage/detailPage.dart';
import 'package:path/path.dart' as p;

class CakeOrderRouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    assert(settings.name.indexOf("/") == 0,
        "[ROUTER] routing MUST Begin with '/'");

    var _reDefine = settings.name.replaceFirst("/", "");
    var _pathParams = p.split(
        _reDefine.split("?").length > 1 ? _reDefine.split("?")[0] : _reDefine);

    //QueryParameters example
    // print(Uri.base.toString()); // http://localhost:8082/game.html?id=15&randomNumber=3.14
    // print(Uri.base.query);  // id=15&randomNumber=3.14
    // print(Uri.base.queryParameters['randomNumber']); // 3.14

    Map<String, dynamic> arguments = settings.arguments ??
        Uri.parse(settings.name.replaceFirst("/", "")).queryParameters ??
        {};
    var _pageName = _pathParams.isNotEmpty ? _pathParams.first : null;
    Widget _pageWidget;

    switch (_pageName) {
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
