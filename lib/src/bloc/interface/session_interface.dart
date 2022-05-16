// BLOC
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:yodravet/src/bloc/event/session_event.dart';
import 'package:yodravet/src/bloc/state/session_state.dart';
import 'package:yodravet/src/model/user.dart';

abstract class Session extends Bloc<SessionEvent, SessionState> {
  Future autoLogIn([String? userEmail, String? password]);
  Future<User> logIn(String userEmail, String password);
  Future<User> googleLogIn();
  Future<User> appleLogIn();
  Future<bool> stravaLogIn();
  Future<bool> stravaLogout();
  Future<bool> changePassword(String email);
  Future signup(String? email, String? password, String? name, String? lastname,
      String? photo);
  @protected
  void logout();

  @protected
  final String userCollectionName = "users";
  User user = User();
  String password = '';

  Session(SessionState initialState) : super(initialState){
    on<SignedEvent>(_onSignedEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<UserChangeEvent>(_onUserChangeEvent);
  }

  void _onSignedEvent(SignedEvent event, Emitter emit) async {
    if (!event.isSignedIn && user.isLogin) _logout();

    emit(LogInState(event.isSignedIn, event.isAutoLogin));
  }

  void _onLogoutEvent(LogoutEvent event, Emitter emit) async {
    if (event.logout) {
      _logout();
      emit(LogOutState(event.logout));
    }
  }

  void _onUserChangeEvent(UserChangeEvent event, Emitter emit) async {
    user = event.user;
    emit(UserChangeState(user));
  }

  void _logout() {
    logout();
    user.logout();
  }
}
