import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(SimpleApp());
}

class SimpleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider<int>.value(
        value: 5, child: MaterialApp(home: SimplePage()));
  }
}

class SimplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<int>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('simple'),
      ),
      body: Center(
        child: Text('$data'),
      ),
    );
  }
}
