import 'package:flutter/foundation.dart';

class Edition {
  static String get currentEdition {
    DateTime _currentDate = DateTime.now();
    String _currentEdition;
    if(_currentDate.month <= 6 || kDebugMode) {
      _currentEdition = "${_currentDate.year}DravetTour";
    } else {
      String lastYear = (_currentDate.year - 1).toString();
      _currentEdition = "${lastYear}DravetTour";
    }

    return _currentEdition;
  }
}