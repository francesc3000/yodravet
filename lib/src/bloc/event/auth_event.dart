import 'package:yodravet/src/model/user.dart';

abstract class AuthEvent {}

class AuthEventEmpty extends AuthEvent {
  @override
  String toString() => 'Empty Event';
}

class AutoLogInEvent extends AuthEvent {
  @override
  String toString() => 'AutoLogin Event';
}

class LogInEvent extends AuthEvent {
  String email;
  String pass;

  LogInEvent({required this.email, required this.pass});

  @override
  String toString() => 'Login Event';
}

class GoogleLogInEvent extends AuthEvent {
  @override
  String toString() => 'GoogleLogIn Event';
}

class AppleLogInEvent extends AuthEvent {
  @override
  String toString() => 'AppleLogInEvent Event';
}
class StravaLogInEvent extends AuthEvent {
  @override
  String toString() => 'StravaLogIn Event';
}

class LogOutEvent extends AuthEvent {
  @override
  String toString() => 'Logout Event';
}

class LogOutSuccessEvent extends AuthEvent {
  @override
  String toString() => 'LogOutSuccessEvent Event';
}

class SignedInEvent extends AuthEvent {
  User user;

  SignedInEvent(this.user);

  @override
  String toString() => 'Login Event';
}

class ChangePasswordEvent extends AuthEvent {
  final String email;

  ChangePasswordEvent(this.email);
  @override
  String toString() => 'Change password Event';
}

class CreateUserEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String lastname;
  final String? photo;

  CreateUserEvent({
      required this.email,
      required this.password,
      required this.name,
      required this.lastname,
      this.photo});

  @override
  String toString() => 'CreateUserEvent Event';
}

class GetSignUpByEmailEvent extends AuthEvent {
  final String email;

  GetSignUpByEmailEvent(this.email);

  @override
  String toString() => 'GetSignUpByEmail Event';
}

class Go2SignupEvent extends AuthEvent {
  @override
  String toString() => 'Go2SignupEvent Event';
}

class InitPostLoginEvent extends AuthEvent {
  @override
  String toString() => 'InitCollaborate Event';
}

class TermsRejectedEvent extends AuthEvent{
  @override
  String toString() => 'TermsRejected Event';
}

class TermsAcceptedEvent extends AuthEvent{
  @override
  String toString() => 'TermsAccepted Event';
}

class CollaborateMaybeLaterEvent extends AuthEvent{
  @override
  String toString() => 'CollaborateMaybeLater Event';
}

class CollaborateFinishEvent extends AuthEvent{
  @override
  String toString() => 'CollaborateFinish Event';
}