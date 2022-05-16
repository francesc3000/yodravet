class CollaboratorDao {
  final String id;
  final String name;
  final String logoPath;
  final String website;
  final String type;

  CollaboratorDao(
      {required this.id,
      required this.name,
      required this.logoPath,
      required this.website,
      required this.type});
}
