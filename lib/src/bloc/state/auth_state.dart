import 'package:yodravet/src/model/user.dart';

abstract class AuthState {}

class AuthInitState extends AuthState {
  @override
  String toString() => 'AuthStateEmpty';
}

class LogInSuccessState extends AuthState {
  User user;

  LogInSuccessState(this.user);

  @override
  String toString() => 'LogIn Successful State';
}

class LogOutSuccessState extends AuthState {
  @override
  String toString() => 'LogOutSuccessState State';
}

class AuthLoadingState extends AuthState {
  final bool isLoading;
  final bool isLoadingGoogle;
  final bool isLoadingApple;

  AuthLoadingState(
      {this.isLoading = false,
      this.isLoadingGoogle = false,
      this.isLoadingApple = false});
  @override
  String toString() => 'Auth Loading State';
}

class ChangePasswordSuccessState extends AuthState {
  User user;

  ChangePasswordSuccessState(this.user);
  @override
  String toString() => 'Change password Ok State';
}

class Go2SignupState extends AuthState {
  @override
  String toString() => 'Go2SignupState State';
}

class AuthStateError extends AuthState {
  final String? message;

  AuthStateError(this.message);

  @override
  String toString() => 'AuthStateError';
}
