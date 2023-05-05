import 'package:shared_preferences/shared_preferences.dart';

import 'interface/preferences.dart';

class PreferencesInterfaceImpl extends Preferences {
  SharedPreferences? _prefs;

  PreferencesInterfaceImpl() {
    initPreferences();
  }

  @override
  Future initPreferences() async {
    _prefs = _prefs ?? await SharedPreferences.getInstance();
  }

  @override
  void keepUser(String authPlatform, String? userId, String? email,
      String password, String fullname) {
    _prefs!.setString('loggedIn', authPlatform);
    _prefs!.setString('userId', userId!);
    _prefs!.setString('userEmail', email!);
    _prefs!.setString('password', password);
    _prefs!.setString('fullname', fullname);
  }

  @override
  void logout() {
    _prefs!.remove('loggedIn');
    _prefs!.remove('token');
    _prefs!.remove('userEmail');
    _prefs!.remove('userId');
    _prefs!.remove('expiryTime');
  }

  @override
  String? getString(String value) => _prefs!.getString(value);

  @override
  bool isFirstLogin() {
    // _prefs!.setInt('year', 0);
    // _prefs!.setBool('isFirstLogin', false);
    int year = _prefs?.getInt('year') ?? DateTime.now().year;
    if(DateTime.now().year!=year){
      return true;
    } else {
      return _prefs?.getBool('isFirstLogin') ?? false;
    }
  }

  @override
  void setFirstLogin() {
    _prefs!.setInt('year', DateTime.now().year);
    _prefs!.setBool('isFirstLogin', false);
  }
}
