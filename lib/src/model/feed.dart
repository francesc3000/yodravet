class Feed {
  final String id;
  final DateTime dateTime;
  String message;
  String? link;

  Feed(this.id, this.dateTime, this.message);

  bool get hasLink => link == null || link!.isEmpty ? false : true;
}