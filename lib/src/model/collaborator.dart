enum CollaboratorType {
  sponsor,
  promoter,
}

class Collaborator {
  final String id;
  final String name;
  final String logoPath;
  final String website;
  CollaboratorType type;

  bool get isSponsor => type == CollaboratorType.sponsor;
  bool get isPromoter => type == CollaboratorType.promoter;

  Collaborator(
      {required this.id,
      required this.name,
      required this.logoPath,
      required this.website,
      this.type = CollaboratorType.sponsor});
}
