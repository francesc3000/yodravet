import 'package:yodravet/src/model/signup.dart';

abstract class SignupState {}

class SignupInitState extends SignupState {
  @override
  String toString() => 'SignupStateEmpty';
}

class UpdateSignupFieldsState extends SignupState {
  final Signup signup;
  final bool isLoading;
  bool showError;

  UpdateSignupFieldsState(
      {required this.signup,
      required this.isLoading,
      this.showError = true});
  @override
  String toString() => 'SignUpFieldsState State';
}

class SignUpSuccessState extends SignupState {
  @override
  String toString() => 'SignUpSuccessState State';
}

class SignupStateError extends SignupState {
  final String message;

  SignupStateError(this.message);

  @override
  String toString() => 'AuthStateError';
}
