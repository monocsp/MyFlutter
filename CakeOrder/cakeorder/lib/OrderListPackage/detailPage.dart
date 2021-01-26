import 'package:flutter/material.dart';
import 'package:cakeorder/addOrderPackage/addOrder.dart';

class DetailPage extends StatefulWidget {
  final String documentId;
  DetailPage({Key key, this.documentId}) : super(key: key);
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends AddOrderParent<DetailPage> {
  @override
  setInitData() {
    isDetailPage = true;
  }
  @override
  thirdLineBuild() {
    
  }

  @override
  Widget build(BuildContext context) {
    return super.build(context);
  }
}
