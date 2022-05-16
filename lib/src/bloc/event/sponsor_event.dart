abstract class SponsorEvent{
}

class SponsorInitDataEvent extends SponsorEvent {
  @override
  String toString() => 'SponsorInitData Event';
}

class Navigate2SponsorWebsiteEvent extends SponsorEvent {
  final String sponsorId;

  Navigate2SponsorWebsiteEvent(this.sponsorId);
  @override
  String toString() => 'Navigate2SponsorWebsite Event';
}

class Navigate2PromoterWebsiteEvent extends SponsorEvent {
  final String promoterId;

  Navigate2PromoterWebsiteEvent(this.promoterId);
  @override
  String toString() => 'Navigate2PromoterWebsite Event';
}

class Navigate2ClubWebsiteEvent extends SponsorEvent {
  final String clubId;

  Navigate2ClubWebsiteEvent(this.clubId);
  @override
  String toString() => 'Navigate2ClubWebsite Event';
}
