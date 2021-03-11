class RaceDao {
  double kmCounter;
  double stageCounter;
  double extraCounter;
  int stage;
  double stageLimit;
  String stageTitle;
  DateTime nextStageDate;
  DateTime startDate;
  DateTime finalDate;

  RaceDao({this.kmCounter, this.stageCounter, this.extraCounter, this.stage, this.stageLimit, this.stageTitle, this.nextStageDate, this.startDate, this.finalDate});
}