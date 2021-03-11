import 'package:yodravet/src/model/user.dart';

abstract class SessionState{}

class SessionStateEmpty extends SessionState {
  @override
  String toString() => 'LoginStateEmpty';
}

class LogInState extends SessionState {
  final bool isSignedIn;
  final bool isAutoLogin;

  LogInState(this.isSignedIn, this.isAutoLogin);

  @override
  String toString() => 'LogInState';
}

class LogOutState extends SessionState {
  final bool logout;

  LogOutState(this.logout);

  @override
  String toString() => 'LogOutState';
}

class UserChangeState extends SessionState {
  final User user;

  UserChangeState(this.user);

  @override
  String toString() => 'UserChangeState';
}

class SessionStateError extends SessionState {
  final String message;

  SessionStateError(this.message);

  @override
  String toString() => 'AuthStateError';
}