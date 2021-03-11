class Race {
  double kmCounter;
  double stageCounter;
  double extraCounter;
  int stage;
  double stageLimit;
  String stageTitle;
  DateTime nextStageDate;
  DateTime startDate;
  DateTime finalDate;

  Race({this.kmCounter=0, this.stageCounter=0, this.extraCounter=0, this.stage=1, this.stageLimit=0, this.stageTitle='', this.nextStageDate, this.startDate, this.finalDate});
}