import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends _BaseStatefulState<MainScreen> {
  @override
  baseMethod() {
    // TODO: implement baseMethod
    return super.baseMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: baseMethod()),
    );
  }
}

abstract class _BaseStatefulState<T extends StatefulWidget> extends State<T> {
  _BaseStatefulState() {
    // Parent constructor
  }

  baseMethod() {
    return Container(
      child: Text("hi"),
    );
    // Parent method
  }
}
