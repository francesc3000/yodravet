import 'package:yodravet/src/model/user.dart';
import 'package:flutter/material.dart';

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

  LogInEvent({@required this.email, @required this.pass});

  @override
  String toString() => 'Login Event';
}

class GoogleLogInEvent extends AuthEvent {
  @override
  String toString() => 'GoogleLogIn Event';
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
  @override
  String toString() => 'Change password Event';
}

class CreateUserEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final String lastname;
  final String photo;

  CreateUserEvent({
      @required this.email,
      @required this.password,
      @required this.name,
      @required this.lastname,
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

class SignupEvent extends AuthEvent {
  final String email;
  final String name;
  final String lastname;
  final String password;
  final String passwordCopy;

  SignupEvent(this.email, this.name, this.lastname, this.password, this.passwordCopy);

  @override
  String toString() => 'Signup Event';
}