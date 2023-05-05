abstract class UserState {}

class UserInitState extends UserState {
  @override
  String toString() => 'UserInitState';
}

class UploadUserFieldsState extends UserState {
  final bool? isStravaLogin;
  final bool lockStravaLogin;
  final String fullname;
  final String? photo;
  final String appVersion;
  // final String usuarios;
  UploadUserFieldsState(
      this.isStravaLogin,
      this.lockStravaLogin,
      this.fullname,
      this.photo,
      this.appVersion,
  );

  @override
  String toString() => 'UploadUserFields State';
}

class UserLogOutState extends UserState {
  @override
  String toString() => 'UserLogOut State';
}

class UserLogInState extends UserState {
  @override
  String toString() => 'UserLogIn State';
}

class UserStateError extends UserState {
  final String message;

  UserStateError(this.message);

  @override
  String toString() => 'UserStateError';
}
