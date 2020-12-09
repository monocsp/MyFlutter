import 'package:flutter/material.dart';

class BookData {
  DateTime _orderDate;
  DateTime _pickupDate;
  String _orderName;
  String _createName;
  String _orderNumber;
  String _cakeName;
  String _cakeSize;
  int _cakePrice;
  get orderDate => _orderDate;
  set orderDate(DateTime value) => _orderDate = value;
  set pickUpDate(DateTime value) => _orderDate = value;
  get pickUpDate => _orderDate;

  String get orderName => _orderName;

  set orderName(String value) => _orderName = value;

  String get createName => _createName;

  set createName(String value) => _createName = value;

  String get orderNumber => _orderNumber;

  set orderNumber(String value) => _orderNumber = value;

  String get cakeName => _cakeName;

  set cakeName(String value) => _cakeName = value;

  String get cakeSize => _cakeSize;

  set cakeSize(String value) => _cakeSize = value;

  int get cakePrice => _cakePrice;

  set cakePrice(int value) => _cakePrice = value;
}
