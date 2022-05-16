import 'dart:async';

import 'package:yodravet/src/model/user_dao.dart';

abstract class AuthRepository {
  Future<String> logIn(String user, String pass);
  Future<UserDao> googleLogIn();
  Future<UserDao> appleLogIn();
  Future<bool> logOut();
  Future<String?> isUserLoggedIn();
  Future<bool> changePassword(String email);
  Future<String> createAuthUser(String email, String password);
}