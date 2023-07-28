import 'package:flutter/material.dart';

class Navigation with ChangeNotifier {
  int _index = 0;
  Navigation();
  int get index {
    return _index;
  }

  void setIndex(int value) {
    _index = value;
    notifyListeners();
  }
}
