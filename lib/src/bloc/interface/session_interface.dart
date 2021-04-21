// BLOC
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:yodravet/src/bloc/event/session_event.dart';
import 'package:yodravet/src/bloc/state/session_state.dart';
import 'package:yodravet/src/model/user.dart';

abstract class Session extends Bloc<SessionEvent, SessionState> {
  @protected
  final String userCollectionName = "users";
  User user = User();
  String password = '';

  Future autoLogIn([String userEmail, String password]);
  Future<User> logIn(String userEmail, String password);
  Future<User> googleLogIn();
  Future<User> appleLogIn();
  Future<bool> stravaLogIn();
  Future<bool> stravaLogout();
  Future<bool> changePassword(String email);
  Future signup(String email, String password, String name, String lastname, String photo);

  @protected
  void logout();

  void _logout() {
    logout();
    user.logout();
  }

  @override
  SessionState get initialState => SessionStateEmpty();

  @override
  Stream<SessionState> mapEventToState(SessionEvent event) async* {
    if (event is SignedEvent) {
      if (!event.isSignedIn && this.user.isLogin) _logout();

      yield LogInState(event.isSignedIn, event.isAutoLogin);
    } else if (event is LogoutEvent) {
      if (event.logout) {
        _logout();
        yield LogOutState(event.logout);
      }
    } else if (event is UserChangeEvent) {
      this.user = user;
      yield UserChangeState(this.user);
    } 
  }
}
