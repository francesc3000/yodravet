abstract class TermsEvent{
}

class StartTermsEvent extends TermsEvent {
  @override
  String toString() => 'StartTerms Event';
}

class RejectTermsEvent extends TermsEvent {
  @override
  String toString() => 'RejectTerms Event';
}

class AcceptTermsEvent extends TermsEvent {
  @override
  String toString() => 'AcceptTerms Event';
}