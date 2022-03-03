import 'package:yodravet/src/model/user.dart';

abstract class SessionEvent{
  SessionEvent();
}

class SignedEvent extends SessionEvent{
  final bool isSignedIn;
  final bool isAutoLogin;
  SignedEvent(this.isSignedIn, this.isAutoLogin);

  @override
  String toString() => 'isSignedIn';
}

class LogoutEvent extends SessionEvent{
  final bool logout;
  LogoutEvent({this.logout=true});

  @override
  String toString() => 'logOut: $logout';
}

class UserChangeEvent extends SessionEvent{
  final User user;
  UserChangeEvent(this.user);

  @override
  String toString() => 'User Change';
}