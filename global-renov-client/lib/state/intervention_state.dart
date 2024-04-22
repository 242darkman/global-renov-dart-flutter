import 'package:flutter/foundation.dart';

class InterventionState with ChangeNotifier {
  String _currentStatus = '';

  String get currentStatus => _currentStatus;

  void setCurrentStatus(String newStatus) {
    _currentStatus = newStatus;
    notifyListeners();
  }
}
