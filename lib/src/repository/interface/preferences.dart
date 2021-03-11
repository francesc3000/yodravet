import 'dart:async';

abstract class Preferences {
//Preferences
  final defaultUsername = "DEFAULT_USERNAME";

  Future initPreferences();
  String getString(String value);
  void keepUser(String authPlatform, String userId, String email, String password, String fullname);
  void logout();
}