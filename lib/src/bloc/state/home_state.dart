abstract class HomeState {}

class HomeInitState extends HomeState {
  @override
  String toString() => 'HomeInitState';
}

class UploadHomeFields extends HomeState {
  final int index;
  final bool isMusicOn;
  
  UploadHomeFields({required this.index, required this.isMusicOn});

  @override
  String toString() => 'UploadHomeFields State';
}
class Navigate2UserPageState extends HomeState {
  @override
  String toString() => 'Navigate2UserPage State';
}

class HomeStateError extends HomeState {
  final String message;

  HomeStateError(this.message);

  @override
  String toString() => 'HomeStateError';
}