import 'package:yodravet/src/model/sponsor.dart';

abstract class SponsorState {}

class SponsorInitState extends SponsorState {
  @override
  String toString() => 'SponsorInitState';
}

class UploadSponsorFields extends SponsorState {
  final List<Sponsor> sponsors;
  final List<Sponsor> promoters;

  UploadSponsorFields({required this.sponsors, required this.promoters});

  @override
  String toString() => 'UploadSponsorFields State';
}

class SponsorStateError extends SponsorState {
  final String message;

  SponsorStateError(this.message);

  @override
  String toString() => 'SponsorStateError';
}