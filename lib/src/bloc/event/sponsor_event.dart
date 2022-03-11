abstract class SponsorEvent{
}

class SponsorInitDataEvent extends SponsorEvent {
  @override
  String toString() => 'SponsorInitData Event';
}

class Navigate2WebsiteEvent extends SponsorEvent {
  final String sponsorId;

  Navigate2WebsiteEvent(this.sponsorId);
  @override
  String toString() => 'Navigate2Website Event';
}
