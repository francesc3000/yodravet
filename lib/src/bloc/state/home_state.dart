abstract class HomeState {}

class HomeInitState extends HomeState {
  @override
  String toString() => 'HomeInitState';
}

class UploadHomeFields extends HomeState {
  final int index;
  
  UploadHomeFields({this.index});

  @override
  String toString() => 'UploadHomeFields State';
}

class Navigate2UserPageState extends HomeState {
  @override
  String toString() => 'Navigate2UserPageState State';
}

class Navigate2LoginState extends HomeState {
  @override
  String toString() => 'Navigate2LoginState State';
}

class Navigate2LoginSuccess extends HomeState {
  @override
  String toString() => 'Navigate2LoginSuccess';
}

class HomeLogOutState extends HomeState {
  @override
  String toString() => 'HomeLogOut State';
}

class HomeStateError extends HomeState {
  final String message;

  HomeStateError(this.message);

  @override
  String toString() => 'HomeStateError';
}