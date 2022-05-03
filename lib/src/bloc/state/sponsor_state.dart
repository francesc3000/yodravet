import 'package:yodravet/src/model/collaborator.dart';

abstract class SponsorState {}

class SponsorInitState extends SponsorState {
  @override
  String toString() => 'SponsorInitState';
}

class UploadSponsorFields extends SponsorState {
  final List<Collaborator> sponsors;
  final List<Collaborator> promoters;
  final List<Collaborator> clubs;

  UploadSponsorFields(
      {required this.sponsors, required this.promoters, required this.clubs});

  @override
  String toString() => 'UploadSponsorFields State';
}

class SponsorStateError extends SponsorState {
  final String message;

  SponsorStateError(this.message);

  @override
  String toString() => 'SponsorStateError';
}
