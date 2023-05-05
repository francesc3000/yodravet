abstract class CollaborateState {}

class CollaborateInitState extends CollaborateState {
  @override
  String toString() => 'CollaborateInitState';
}

class UploadCollaborateFields extends CollaborateState {
  UploadCollaborateFields();

  @override
  String toString() => 'UploadCollaborateFields State';
}

class CollaborateStateError extends CollaborateState {
  final String message;

  CollaborateStateError(this.message);

  @override
  String toString() => 'CollaborateStateError';
}
