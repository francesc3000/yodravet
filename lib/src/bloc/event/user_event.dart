abstract class UserEvent{
}

class UserEventEmpty extends UserEvent{
  @override
  String toString() => 'Empty Event';
}

class LoadInitialDataEvent extends UserEvent{
  @override
  String toString() => 'LoadInitialData Event';
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

class DeleteAccountEvent extends UserEvent {
  @override
  String toString() => 'DeleteAccount Event';
}

class UploadUserFieldsEvent extends UserEvent {
  @override
  String toString() => 'UploadUserFields Event';
}