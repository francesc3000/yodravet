abstract class TermsState {}

class TermsInitState extends TermsState {
  @override
  String toString() => 'TermsInitState';
}

class UploadTermsFields extends TermsState {
  UploadTermsFields();

  @override
  String toString() => 'UploadTermsFields State';
}

class TermsStateError extends TermsState {
  final String message;

  TermsStateError(this.message);

  @override
  String toString() => 'TermsStateError';
}
