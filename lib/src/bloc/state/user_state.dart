import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/activity_purchase.dart';
abstract class UserState {}

class UserInitState extends UserState {
  @override
  String toString() => 'UserInitState';
}

class UploadUserFieldsState extends UserState {
  final List<Activity> activities;
  final bool isStravaLogin;
  final bool lockStravaLogin;
  final String fullname;
  final String photo;
  final DateTime beforeDate;
  final DateTime afterDate;
  final int filterDonorTab;
  final List<ActivityPurchase> donors;
  final String usuarios;
  UploadUserFieldsState(this.activities, this.isStravaLogin, this.lockStravaLogin, this.fullname, this.photo, this.beforeDate, this.afterDate, this.filterDonorTab, this.donors, this.usuarios);

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