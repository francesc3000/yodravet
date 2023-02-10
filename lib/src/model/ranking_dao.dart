class RankingDao {
  String id;
  String? run;
  String? walk;
  String? ride;
  bool isTeam;
  String userFullname;
  String userPhoto;

  RankingDao(this.id, this.run, this.walk, this.ride, this.isTeam,
      this.userFullname, this.userPhoto);
}
