import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:cakeorder/ProviderPackage/cakeList.dart';
import 'package:flutter/cupertino.dart';

class OrderPage extends StatefulWidget {
  @override
  _AddOrderState createState() => _AddOrderState();
  // State createState() => new MyAppState();
}

class _AddOrderState extends State<OrderPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<CakeData> temp = Provider.of<List<CakeData>>(context);
    // print(temp);

    return Scaffold(
        key: scaffoldKey,
        body: GestureDetector(
            onTap: () {
              //If tap ouside, hide keyboard
              List<CakeData> temp = Provider.of<List<CakeData>>(context);
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              child: Text('hi'),
            )));
  }
}
