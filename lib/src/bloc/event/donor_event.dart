abstract class DonorEvent{
}

class DonorEventEmpty extends DonorEvent{
  @override
  String toString() => 'Empty Event';
}

class LoadInitialDataEvent extends DonorEvent{
  @override
  String toString() => 'LoadInitialData Event';
}

class GetStravaActivitiesEvent extends DonorEvent {
  @override
  String toString() => 'GetStravaActivities Event';
}

class DonateKmEvent extends DonorEvent {
  final String? stravaId;

  DonateKmEvent(this.stravaId);
  @override
  String toString() => 'DonateKmEvent Event';
}

class ShareActivityEvent extends DonorEvent {
  final String message2Share;

  ShareActivityEvent(this.message2Share);
  @override
  String toString() => 'ShareActivity Event';
}

class JoinTeamEvent extends DonorEvent {
  final String teamId;

  JoinTeamEvent(this.teamId);
  @override
  String toString() => 'JoinTeam Event';
}

class DisJoinTeamEvent extends DonorEvent {
  final String teamId;

  DisJoinTeamEvent(this.teamId);
  @override
  String toString() => 'DisJoinTeam Event';
}

class UploadDonorFieldsEvent extends DonorEvent {
  @override
  String toString() => 'UploadDonorFields Event';
}