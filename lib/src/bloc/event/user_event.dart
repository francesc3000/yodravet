abstract class UserEvent{
}

class UserEventEmpty extends UserEvent{
  @override
  String toString() => 'Empty Event';
}

class UserLogOutEvent extends UserEvent {
  @override
  String toString() => 'UserLogOut Event';
}

class UserLogInEvent extends UserEvent {
  @override
  String toString() => 'UserLogIn Event';
}

class ConnectWithStravaEvent extends UserEvent {
  @override
  String toString() => 'ConnectWithStrava Event';
}

class GetStravaActivitiesEvent extends UserEvent {
  @override
  String toString() => 'GetStravaActivities Event';
}

class DonateKmEvent extends UserEvent {
  final String? stravaId;

  DonateKmEvent(this.stravaId);
  @override
  String toString() => 'DonateKmEvent Event';
}

class LoadInitialDataEvent extends UserEvent {
  @override
  String toString() => 'LoadInitialData Event';
}

class UploadUserFieldsEvent extends UserEvent {
  @override
  String toString() => 'UploadUserFields Event';
}

class ChangeUserPodiumTabEvent extends UserEvent {
  final int indexTab;

  ChangeUserPodiumTabEvent(this.indexTab);
  @override
  String toString() => 'ChangeUserPodiumTab Event';
}

class ShareActivityEvent extends UserEvent {
  final String message2Share;

  ShareActivityEvent(this.message2Share);
  @override
  String toString() => 'ShareActivity Event';
}