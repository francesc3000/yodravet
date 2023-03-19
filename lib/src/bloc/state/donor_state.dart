import 'package:yodravet/src/model/activity.dart';
import 'package:yodravet/src/model/team.dart';

abstract class DonorState {}

class DonorInitState extends DonorState {
  @override
  String toString() => 'DonorInitState';
}

class UploadDonorFieldsState extends DonorState {
  final List<Activity>? activities;
  final List<Team>? teams;
  final String? currentTeamId;
  final DateTime? beforeDate;
  final DateTime? afterDate;
  final bool isStravaLogin;
  // final String usuarios;
  UploadDonorFieldsState(
      this.activities,
      this.teams,
      this.currentTeamId,
      this.beforeDate,
      this.afterDate,
      this.isStravaLogin,
  );

  @override
  String toString() => 'UploadDonorFields State';
}

class DonorStateError extends DonorState {
  final String message;

  DonorStateError(this.message);

  @override
  String toString() => 'DonorStateError';
}
