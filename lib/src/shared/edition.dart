class Edition {
  static String get currentEdition {
    DateTime _currentDate = DateTime.now();
    String _currentEdition;
    if(_currentDate.month<6) {
      String lastYear = (_currentDate.year - 1).toString();
      _currentEdition = "${lastYear}DravetTour";
    } else {
      _currentEdition = "${_currentDate.year}DravetTour";
    }

    return _currentEdition;
  }
}