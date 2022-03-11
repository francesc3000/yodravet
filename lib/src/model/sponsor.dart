enum SponsorType {
  sponsor,
  promoter,
}

class Sponsor {
  final String id;
  final String name;
  final String logoPath;
  final String website;
  SponsorType type;

  bool get isSponsor => type == SponsorType.sponsor;
  bool get isPromoter => type == SponsorType.promoter;

  Sponsor(
      {required this.id,
      required this.name,
      required this.logoPath,
      required this.website,
      this.type = SponsorType.sponsor});
}
