import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  dynamic _user;

  dynamic get user => _user;

  void setUser(dynamic user) {
    _user = user;
    notifyListeners();
  }
}
